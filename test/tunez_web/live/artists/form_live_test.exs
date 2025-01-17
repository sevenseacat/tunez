defmodule TunezWeb.Artists.FormLiveTest do
  use TunezWeb.ConnCase, async: true

  alias Tunez.Music, warn: false

  describe "creating a new artist" do
    @tag skip: "Also need to change `_conn` to `conn` below"
    test "errors for forbidden users", %{conn: _conn} do
      # assert_raise(Ash.Error.Forbidden, fn ->
      #   conn
      #   |> insert_and_authenticate_user()
      #   |> visit(~p"/artists/new")
      # end)
    end

    @tag skip: "Also need to change `_conn` to `conn` below"
    test "succeeds when valid details are entered", %{conn: _conn} do
      # conn
      # |> insert_and_authenticate_user(:admin)
      # |> visit(~p"/artists/new")
      # |> fill_in("Name", with: "Temperance")
      # |> click_button("Save")
      # |> assert_has(flash(:info), text: "Artist saved successfully")

      # assert get_by_name(Tunez.Music.Artist, "Temperance")
    end

    @tag skip: "Also need to change `_conn` to `conn` below"
    test "fails when invalid details are entered", %{conn: _conn} do
      # conn
      # |> insert_and_authenticate_user(:admin)
      # |> visit(~p"/artists/new")
      # |> fill_in("Name", with: "")
      # |> click_button("Save")
      # |> assert_has(flash(:error), text: "Could not save artist data")

      # assert Music.read_artists!() == []
    end
  end

  describe "updating an existing artist" do
    @tag skip: "Also need to change `_conn` to `conn` below"
    test "errors for forbidden users", %{conn: _conn} do
      # artist = generate(artist())

      # assert_raise(Ash.Error.Forbidden, fn ->
      #   conn
      #   |> insert_and_authenticate_user()
      #   |> visit(~p"/artists/#{artist}/edit")
      # end)
    end

    @tag skip: "Also need to change `_conn` to `conn` below"
    test "succeeds when valid details are entered", %{conn: _conn} do
      # artist = generate(artist(name: "Old Name"))

      # conn
      # |> insert_and_authenticate_user(:admin)
      # |> visit(~p"/artists/#{artist}/edit")
      # |> fill_in("Name", with: "New Name")
      # |> click_button("Save")
      # |> assert_has(flash(:info), text: "Artist saved successfully")

      # updated_artist = Music.get_artist_by_id!(artist.id)
      # assert updated_artist.name == "New Name"
    end

    @tag skip: "Also need to change `_conn` to `conn` below"
    test "fails when invalid details are entered", %{conn: _conn} do
      # artist = generate(artist(name: "Old Name"))

      # conn
      # |> insert_and_authenticate_user(:admin)
      # |> visit(~p"/artists/#{artist}/edit")
      # |> fill_in("Name", with: "")
      # |> click_button("Save")
      # |> assert_has(flash(:error), text: "Could not save artist data")

      # updated_artist = Music.get_artist_by_id!(artist.id)
      # assert updated_artist.name == "Old Name"
    end
  end
end
