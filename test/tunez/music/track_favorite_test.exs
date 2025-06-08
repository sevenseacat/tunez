defmodule Tunez.Music.TrackFavoriteTest do
  use Tunez.DataCase, async: true

  alias Tunez.Music

  describe "Tunez.Music.favorite_track/2" do
    test "allows a user to favorite a track" do
      user = generate(user())
      track = generate(track(authorize?: false))

      assert {:ok, _favorite} = Music.favorite_track(track, actor: user)
    end

    test "prevents duplicate favorites" do
      user = generate(user())
      track = generate(track(authorize?: false))

      assert {:ok, _favorite} = Music.favorite_track(track, actor: user)
      assert {:error, _} = Music.favorite_track(track, actor: user)
    end

    test "requires authentication" do
      track = generate(track(authorize?: false))

      assert {:error, _} = Music.favorite_track(track, actor: nil)
    end
  end

  describe "Tunez.Music.unfavorite_track/2" do
    test "allows a user to unfavorite a track" do
      user = generate(user())
      track = generate(track(authorize?: false))

      {:ok, _favorite} = Music.favorite_track(track, actor: user)
      assert :ok = Music.unfavorite_track(track, actor: user)
    end

    test "handles unfavoriting a track that wasn't favorited" do
      user = generate(user())
      track = generate(track(authorize?: false))

      # Should return :ok even if track wasn't favorited (no-op)
      assert :ok = Music.unfavorite_track(track, actor: user)
    end

    test "requires authentication" do
      track = generate(track(authorize?: false))

      assert {:error, _} = Music.unfavorite_track(track, actor: nil)
    end
  end

  describe "favorited_by_me calculation" do
    test "returns true when track is favorited by current user" do
      user = generate(user())
      track = generate(track(authorize?: false))

      # Initially not favorited
      track_with_calc = Ash.load!(track, :favorited_by_me, actor: user)
      refute track_with_calc.favorited_by_me

      # After favoriting
      {:ok, _favorite} = Music.favorite_track(track, actor: user)
      track_with_calc = Ash.load!(track, :favorited_by_me, actor: user)
      assert track_with_calc.favorited_by_me
    end

    test "returns false when track is favorited by other user" do
      user1 = generate(user())
      user2 = generate(user())
      track = generate(track(authorize?: false))

      # User1 favorites the track
      {:ok, _favorite} = Music.favorite_track(track, actor: user1)

      # User2 should see it as not favorited
      track_with_calc = Ash.load!(track, :favorited_by_me, actor: user2)
      refute track_with_calc.favorited_by_me
    end

    test "returns false when no actor present" do
      track = generate(track(authorize?: false))

      track_with_calc = Ash.load!(track, :favorited_by_me, actor: nil)
      refute track_with_calc.favorited_by_me
    end
  end

  describe "relationships" do
    test "track has many track_favorites" do
      track = generate(track(authorize?: false))
      user1 = generate(user())
      user2 = generate(user())

      {:ok, _} = Music.favorite_track(track, actor: user1)
      {:ok, _} = Music.favorite_track(track, actor: user2)

      track_with_favorites = Ash.load!(track, :track_favorites)
      assert length(track_with_favorites.track_favorites) == 2
    end

    test "user has many track_favorites" do
      user = generate(user())
      track1 = generate(track(authorize?: false))
      track2 = generate(track(authorize?: false))

      {:ok, _} = Music.favorite_track(track1, actor: user)
      {:ok, _} = Music.favorite_track(track2, actor: user)

      user_with_favorites = Ash.load!(user, :track_favorites)
      assert length(user_with_favorites.track_favorites) == 2
    end

    test "many_to_many relationship works correctly" do
      user = generate(user())
      track1 = generate(track(authorize?: false))
      track2 = generate(track(authorize?: false))

      {:ok, _} = Music.favorite_track(track1, actor: user)
      {:ok, _} = Music.favorite_track(track2, actor: user)

      user_with_tracks = Ash.load!(user, :favorited_tracks)
      track_ids = Enum.map(user_with_tracks.favorited_tracks, & &1.id)

      assert track1.id in track_ids
      assert track2.id in track_ids
    end
  end

  describe "cascade delete behavior" do
    test "track favorites are deleted when track is deleted" do
      user = generate(user())
      track = generate(track(authorize?: false))

      {:ok, favorite} = Music.favorite_track(track, actor: user)

      # Delete the track
      :ok = Ash.destroy!(track, authorize?: false)

      # Favorite should be gone
      assert match?(
               {:error, _},
               Ash.get(Tunez.Music.TrackFavorite, [favorite.track_id, favorite.user_id])
             )
    end

    test "track favorites are deleted when user is deleted" do
      user = generate(user())
      track = generate(track(authorize?: false))

      {:ok, favorite} = Music.favorite_track(track, actor: user)

      # Delete the user directly from database since User has no destroy action
      Tunez.Repo.delete!(user)

      # Favorite should be gone due to cascade delete
      assert match?(
               {:error, _},
               Ash.get(Tunez.Music.TrackFavorite, [favorite.track_id, favorite.user_id])
             )
    end
  end

  describe "policies" do
    test "only authenticated users can create favorites" do
      track = generate(track(authorize?: false))

      # Anonymous user cannot favorite (gets invalid error due to relate_actor)
      assert {:error, %Ash.Error.Invalid{}} = Music.favorite_track(track, actor: nil)

      # Authenticated user can favorite
      user = generate(user())
      assert {:ok, _} = Music.favorite_track(track, actor: user)
    end

    test "only authenticated users can remove favorites" do
      user = generate(user())
      track = generate(track(authorize?: false))

      {:ok, _} = Music.favorite_track(track, actor: user)

      # Anonymous user cannot unfavorite
      assert {:error, %Ash.Error.Forbidden{}} = Music.unfavorite_track(track, actor: nil)

      # Authenticated user can unfavorite
      assert :ok = Music.unfavorite_track(track, actor: user)
    end

    test "users can read all track favorites" do
      user1 = generate(user())
      user2 = generate(user())
      track = generate(track(authorize?: false))

      {:ok, _} = Music.favorite_track(track, actor: user1)

      # User2 can read all favorites (policy allows always for read)
      favorites = Ash.read!(Tunez.Music.TrackFavorite, actor: user2)
      assert length(favorites) == 1
    end
  end
end
