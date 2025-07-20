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

    @tag skip: "Can be enabled during chapter 8.
      Also need to change `_conn` to `conn` below"
    test "shows the track details", %{conn: _conn} do
      # album = generate(album(track_count: 2))

      # conn
      # |> visit(~p"/artists/#{album.artist_id}/")
      # |> within("#album-#{album.id}", fn session ->
      #   session
      #   |> assert_has("td", text: Enum.at(album.tracks, 0).name)
      #   |> assert_has("td", text: Enum.at(album.tracks, 1).name)
      # end)
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
  end
end
