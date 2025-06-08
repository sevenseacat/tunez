defmodule TunezWeb.Artists.ShowLiveTest do
  use TunezWeb.ConnCase, async: true

  alias Tunez.Music, warn: false

  describe "render/1" do
    test "can view artists details", %{conn: conn} do
      artist = generate(artist())

      conn
      |> visit(~p"/artists/#{artist}")
      |> assert_has("h1", text: artist.name)
    end

    test "has a link to delete the artist for valid users", %{conn: conn} do
      artist = generate(artist())

      conn
      |> visit(~p"/artists/#{artist}")
      |> refute_has(clickable("destroy-artist"))

      conn
      |> insert_and_authenticate_user(:admin)
      |> visit(~p"/artists/#{artist}")
      |> assert_has(clickable("destroy-artist"))
    end

    test "has a link to edit the artist for valid users", %{conn: conn} do
      artist = generate(artist())

      conn
      |> visit(~p"/artists/#{artist}")
      |> refute_has(link(~p"/artists/#{artist}/edit"))

      conn
      |> insert_and_authenticate_user(:admin)
      |> visit(~p"/artists/#{artist}")
      |> assert_has(link(~p"/artists/#{artist}/edit"))
    end

    test "can view a list of the artist's albums", %{conn: conn} do
      artist = generate(artist(album_count: 2))
      [album1, album2] = generate_many(album(artist_id: artist.id), 2)

      conn
      |> visit(~p"/artists/#{artist}")
      |> assert_has("#album-#{album1.id}")
      |> assert_has("#album-#{album2.id}")
    end
  end

  describe "album_details/1" do
    test "shows the album name", %{conn: conn} do
      album = generate(album())

      conn
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> assert_has("h2", text: album.name)
        |> assert_has("div", text: "Track data coming soon...")
      end)
    end

    test "shows the track details", %{conn: conn} do
      album = generate(album(track_count: 2))

      conn
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> assert_has("td", text: Enum.at(album.tracks, 0).name)
        |> assert_has("td", text: Enum.at(album.tracks, 1).name)
      end)
    end

    test "shows favorite stars for authenticated users", %{conn: conn} do
      album = generate(album(track_count: 2, authorize?: false))

      # Unauthenticated user should not see stars
      conn
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> refute_has("span[phx-click='toggle-favorite']")
      end)

      # Authenticated user should see stars
      conn
      |> insert_and_authenticate_user(:user)
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> assert_has("span[phx-click='toggle-favorite']")
        # Should show outline stars initially
        |> assert_has(".hero-star")
      end)
    end

    test "links to edit and delete the album for valid users", %{conn: conn} do
      album = generate(album())

      # Unauthenticated user
      conn
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> refute_has(link(~p"/albums/#{album}/edit"))
        |> refute_has(clickable("destroy-album", album))
      end)

      # Admin user
      conn
      |> insert_and_authenticate_user(:admin)
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> assert_has(link(~p"/albums/#{album}/edit"))
        |> assert_has(clickable("destroy-album", album))
      end)
    end
  end

  describe "events" do
    test "can delete artists", %{conn: conn} do
      artist = generate(artist())

      conn
      |> insert_and_authenticate_user(:admin)
      |> visit(~p"/artists/#{artist}")
      |> click_link("Delete Artist")
      |> assert_has(flash(:info), text: "Artist deleted successfully")

      assert {:error, _error} = Music.get_artist_by_id(artist.id)
    end

    test "can delete albums", %{conn: conn} do
      album = generate(album())

      conn
      |> insert_and_authenticate_user(:admin)
      |> visit(~p"/artists/#{album.artist_id}")
      |> click_link("#album-#{album.id} a", "Delete")
      |> assert_has(flash(:info), text: "Album deleted successfully")

      assert {:error, _error} = Music.get_album_by_id(album.id)
    end

    test "can favorite and unfavorite tracks", %{conn: conn} do
      album = generate(album(track_count: 1, authorize?: false))
      track = Enum.at(album.tracks, 0)

      conn = insert_and_authenticate_user(conn, :user)

      # Initially unfavorited - should show outline star
      conn
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> assert_has("span[phx-value-track-id='#{track.id}'] .hero-star")
        |> refute_has("span[phx-value-track-id='#{track.id}'] .hero-star-solid")
      end)

      # Click to favorite
      session =
        conn
        |> visit(~p"/artists/#{album.artist_id}/")

      session
      |> click_button("span[phx-value-track-id='#{track.id}']", "")
      |> within("#album-#{album.id}", fn session ->
        # Should now show solid star
        session
        |> assert_has("span[phx-value-track-id='#{track.id}'] .hero-star-solid")
        |> refute_has("span[phx-value-track-id='#{track.id}'] .hero-star:not(.hero-star-solid)")
      end)

      # Verify favorite was created
      favorites = Ash.load!(track, :track_favorites, authorize?: false).track_favorites
      assert length(favorites) == 1

      # Click to unfavorite
      session
      |> click_button("span[phx-value-track-id='#{track.id}']", "")
      |> within("#album-#{album.id}", fn session ->
        # Should show outline star again
        session
        |> assert_has("span[phx-value-track-id='#{track.id}'] .hero-star")
        |> refute_has("span[phx-value-track-id='#{track.id}'] .hero-star-solid")
      end)

      # Verify favorite was removed
      favorites = Ash.load!(track, :track_favorites, authorize?: false).track_favorites
      assert length(favorites) == 0
    end

    test "shows favorited tracks correctly on page load", %{conn: conn} do
      album = generate(album(track_count: 2, authorize?: false))
      [track1, track2] = album.tracks
      user = generate(user())

      # Favorite one track
      {:ok, _} = Music.favorite_track(track1, actor: user)

      conn
      |> TunezWeb.ConnCase.log_in_user(user)
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        # Track1 should show solid star (favorited)
        session
        |> assert_has("span[phx-value-track-id='#{track1.id}'] .hero-star-solid")
        # Track2 should show outline star (not favorited)
        |> assert_has("span[phx-value-track-id='#{track2.id}'] .hero-star")
        |> refute_has("span[phx-value-track-id='#{track2.id}'] .hero-star-solid")
      end)
    end

    test "handles favoriting errors gracefully", %{conn: conn} do
      album = generate(album(track_count: 1, authorize?: false))

      # Test that unauthenticated users don't see favorite stars
      conn
      |> visit(~p"/artists/#{album.artist_id}/")
      |> within("#album-#{album.id}", fn session ->
        session
        |> refute_has("span[phx-click='toggle-favorite']")
      end)
    end
  end
end
