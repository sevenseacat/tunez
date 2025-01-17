defmodule TunezWeb.Graphql.ArtistTest do
  use TunezWeb.ConnCase, async: true

  describe "queries" do
    @tag :skip
    test "getArtistById" do
      # artist = generate(artist(name: "Test Name"))
      # album = generate(album(artist_id: artist.id))

      # assert {:ok, resp} =
      #          """
      #          query getArtistById($id: ID!) {
      #            getArtistById(id: $id) {
      #              name
      #              albums { name }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"id" => artist.id}
      #          )

      # assert resp.data["getArtistById"]["name"] == "Test Name"
      # assert resp.data["getArtistById"]["albums"] == [%{"name" => album.name}]
    end

    @tag :skip
    test "searchArtists" do
      # generate(artist(name: "hello"))
      # generate(artist(name: "goodbye"))
      # generate(artist(name: "what?"))

      # assert {:ok, resp} =
      #          """
      #          query searchArtists($query: String, $sort: [ArtistSortInput]) {
      #            searchArtists(query: $query, sort: $sort) {
      #              results {
      #              name}
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{
      #              "query" => "o",
      #              "sort" => [%{"field" => "NAME", "order" => "ASC"}]
      #            }
      #          )

      # names = Enum.map(resp.data["searchArtists"]["results"], & &1["name"])
      # assert names == ["goodbye", "hello"]
    end
  end

  describe "mutations" do
    @tag :skip
    test "createArtist via Absinthe.run" do
      # user = generate(user(role: :admin))

      # assert {:ok, resp} =
      #          """
      #          mutation createArtist($input: CreateArtistInput!) {
      #            createArtist(input: $input) {
      #              result { name }
      #              errors { message }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"input" => %{"name" => "New Artist"}},
      #            context: %{actor: user}
      #          )

      # assert Enum.empty?(resp.data["createArtist"]["errors"])
      # assert resp.data["createArtist"]["result"]["name"] == "New Artist"
    end

    @tag skip: "Also need to change `_conn` to `conn` below"
    test "createArtist via HTTP request", %{conn: _conn} do
      # user = generate(user(role: :admin))

      # conn =
      #   conn
      #   |> put_req_header("authorization", "Bearer #{user.__metadata__.token}")
      #   |> post("/gql", %{
      #     "query" => """
      #     mutation CreateArtist($input: CreateArtistInput!) {
      #       createArtist(input: $input) {
      #         result { name }
      #         errors { message }
      #       }
      #     }
      #     """,
      #     "variables" => %{"input" => %{"name" => "New Artist"}}
      #   })

      # assert json_response(conn, 200) == %{
      #          "data" => %{
      #            "createArtist" => %{
      #              "errors" => [],
      #              "result" => %{"name" => "New Artist"}
      #            }
      #          }
      #        }
    end

    @tag :skip
    test "updateArtist" do
      # user = generate(user(role: :admin))
      # artist = generate(artist())

      # assert {:ok, resp} =
      #          """
      #          mutation updateArtist($id: ID! $input: UpdateArtistInput) {
      #            updateArtist(id: $id, input: $input) {
      #              result { name }
      #              errors { message }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"id" => artist.id, "input" => %{"name" => "A different name"}},
      #            context: %{actor: user}
      #          )

      # assert Enum.empty?(resp.data["updateArtist"]["errors"])
      # assert resp.data["updateArtist"]["result"]["name"] == "A different name"
    end

    @tag :skip
    test "destroyArtist" do
      # user = generate(user(role: :admin))
      # artist = generate(artist())

      # assert {:ok, resp} =
      #          """
      #          mutation destroyArtist($id: ID!) {
      #            destroyArtist(id: $id) {
      #              result { name }
      #              errors { message }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"id" => artist.id},
      #            context: %{actor: user}
      #          )

      # assert Enum.empty?(resp.data["destroyArtist"]["errors"])
      # assert resp.data["destroyArtist"]["result"]["name"] == artist.name
    end
  end
end
