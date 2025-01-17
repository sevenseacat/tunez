defmodule TunezWeb.Graphql.AlbumTest do
  use TunezWeb.ConnCase, async: true

  describe "mutations" do
    @tag :skip
    test "createAlbum" do
      # user = generate(user(role: :admin))
      # artist = generate(artist())

      # assert {:ok, resp} =
      #          """
      #          mutation createAlbum($input: CreateAlbumInput!) {
      #            createAlbum(input: $input) {
      #              result { name }
      #              errors { message }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{
      #              "input" => %{
      #                "artistId" => artist.id,
      #                "name" => "New Album",
      #                "yearReleased" => 2022
      #              }
      #            },
      #            context: %{actor: user}
      #          )

      # assert Enum.empty?(resp.data["createAlbum"]["errors"])
      # assert resp.data["createAlbum"]["result"]["name"] == "New Album"
    end

    @tag :skip
    test "updateAlbum" do
      # user = generate(user(role: :admin))
      # album = generate(album())

      # assert {:ok, resp} =
      #          """
      #          mutation updateAlbum($id: ID! $input: UpdateAlbumInput) {
      #            updateAlbum(id: $id, input: $input) {
      #              result { name }
      #              errors { message }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"id" => album.id, "input" => %{"name" => "A different name"}},
      #            context: %{actor: user}
      #          )

      # assert Enum.empty?(resp.data["updateAlbum"]["errors"])
      # assert resp.data["updateAlbum"]["result"]["name"] == "A different name"
    end

    @tag :skip
    test "destroyAlbum" do
      # user = generate(user(role: :admin))
      # album = generate(album())

      # assert {:ok, resp} =
      #          """
      #          mutation destroyAlbum($id: ID!) {
      #            destroyAlbum(id: $id) {
      #              result { name }
      #              errors { message }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"id" => album.id},
      #            context: %{actor: user}
      #          )

      # assert Enum.empty?(resp.data["destroyAlbum"]["errors"])
      # assert resp.data["destroyAlbum"]["result"]["name"] == album.name
    end
  end
end
