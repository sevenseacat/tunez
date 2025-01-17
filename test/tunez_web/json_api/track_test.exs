defmodule TunezWeb.JsonApi.TrackTest do
  use TunezWeb.ConnCase, async: true

  # import AshJsonApi.Test

  @tag skip: "Can be enabled during chapter 8. Also uncomment the import at the top of this file"
  test "can read an album's tracks" do
    # album = generate(album())
    # generate(track(album_id: album.id, name: "first!"))
    # generate(track(album_id: album.id, name: "second!"))
    # generate(track(name: "different album, fam"))

    # get(
    #   Tunez.Music,
    #   "/albums/#{album.id}/tracks",
    #   router: TunezWeb.AshJsonApiRouter,
    #   status: 200
    # )
    # |> assert_data_matches([
    #   %{"attributes" => %{"name" => "first!"}},
    #   %{"attributes" => %{"name" => "second!"}}
    # ])
  end
end
