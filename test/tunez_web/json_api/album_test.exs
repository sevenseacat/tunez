defmodule TunezWeb.JsonApi.AlbumTest do
  use TunezWeb.ConnCase, async: true

  # import AshJsonApi.Test

  @tag skip: "Also uncomment the import at the top of this file"
  test "can read an artist's albums" do
    # artist = generate(artist())
    # generate(album(artist_id: artist.id, name: "first!", year_released: 2020))
    # generate(album(artist_id: artist.id, name: "second!", year_released: 2022))

    # get(
    #   Tunez.Music,
    #   "/artists/#{artist.id}/albums",
    #   router: TunezWeb.AshJsonApiRouter,
    #   status: 200
    # )
    # |> assert_data_matches([
    #   %{"attributes" => %{"name" => "second!"}},
    #   %{"attributes" => %{"name" => "first!"}}
    # ])
  end

  @tag skip: "Also uncomment the import at the top of this file"
  test "can create an album" do
    # user = generate(user(role: :admin))
    # artist = generate(artist())

    # post(
    #   Tunez.Music,
    #   "/albums",
    #   %{
    #     data: %{
    #       attributes: %{artist_id: artist.id, name: "New JSON:API album!", year_released: 2015}
    #     }
    #   },
    #   router: TunezWeb.AshJsonApiRouter,
    #   status: 201,
    #   actor: user
    # )
    # |> assert_data_matches(%{
    #   "attributes" => %{"name" => "New JSON:API album!"}
    # })
  end

  @tag skip: "Also uncomment the import at the top of this file"
  test "can update an album" do
    # user = generate(user(role: :admin))
    # album = generate(album())

    # patch(
    #   Tunez.Music,
    #   "/albums/#{album.id}",
    #   %{
    #     data: %{
    #       attributes: %{name: "Updated name", year_released: 2001}
    #     }
    #   },
    #   router: TunezWeb.AshJsonApiRouter,
    #   status: 200,
    #   actor: user
    # )
    # |> assert_data_matches(%{
    #   "attributes" => %{"name" => "Updated name"}
    # })
  end

  @tag skip: "Also uncomment the import at the top of this file"
  test "can delete an album" do
    # user = generate(user(role: :admin))
    # album = generate(album(name: "Test"))

    # delete(
    #   Tunez.Music,
    #   "/albums/#{album.id}",
    #   router: TunezWeb.AshJsonApiRouter,
    #   status: 200,
    #   actor: user
    # )
    # |> assert_data_matches(%{
    #   "attributes" => %{"name" => "Test"}
    # })
  end
end
