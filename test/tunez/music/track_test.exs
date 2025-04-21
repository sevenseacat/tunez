defmodule Tunez.Music.TrackTest do
  use Tunez.DataCase, async: true

  alias Tunez.Music, warn: false

  describe "policies" do
    test "anyone can read track records" do
      track = generate(track(seed?: true))
      assert Ash.can?({Music.Track, :read}, nil, data: track)
    end

    test "track records can't be updated unless through the Album resource" do
      admin = generate(user(role: :admin))

      album = generate(album())
      track = generate(track(seed?: true, album_id: album.id))

      refute Ash.can?({track, :update}, admin)

      # Assert that an update through the album can succeed, and update the
      # data in the database
      updated_album =
        Music.update_album!(
          album,
          %{tracks: [%{order: 1, name: "new!!", duration: "2:22", duration_seconds: "142"}]},
          actor: admin
        )

      updated_track = Ash.load!(updated_album, [:tracks]) |> Map.get(:tracks) |> List.first()
      assert updated_track.name == "new!!"
    end
  end
end
