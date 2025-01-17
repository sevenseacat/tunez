defmodule TunezWeb.Music.AlbumTest do
  use Tunez.DataCase, async: true

  alias Tunez.Accounts.Notification, warn: false
  alias Tunez.Music, warn: false

  describe "Tunez.Music.create_album/1-2" do
    @tag :skip
    test "stores the actor that created the record" do
      # actor = generate(user(role: :admin))
      # artist = generate(artist())

      # album =
      #   Music.create_album!(
      #     %{name: "New Album", artist_id: artist.id, year_released: 2024},
      #     actor: actor
      #   )

      # assert album.created_by_id == actor.id
      # assert album.updated_by_id == actor.id
    end

    @tag skip: "can be enabled during chapter 9"
    test "queues a job to send notifications" do
      # actor = generate(user(role: :admin))
      # artist = generate(artist())

      # album =
      #   Music.create_album!(
      #     %{name: "New Album", artist_id: artist.id, year_released: 2024},
      #     actor: actor
      #   )

      # assert_enqueued(queue: "album_notifications", args: %{primary_key: %{id: album.id}})
    end
  end

  describe "Tunez.Music.update_album/2-3" do
    @tag :skip
    test "stores the actor that updated the record" do
      # actor = generate(user(role: :admin))

      # album = generate(album(name: "The Old Name"))
      # refute album.updated_by_id == actor.id

      # album = Music.update_album!(album, %{name: "The New Name"}, actor: actor)
      # assert album.updated_by_id == actor.id
    end
  end

  describe "Tunez.Music.destroy_album/1-2" do
    @tag skip: "can be enabled during chapter 9"
    test "deletes any notifications about the album" do
      # album = generate(album())
      # %{id: to_stay_id} = generate(notification())
      # _to_go = generate(notification(album_id: album.id))

      # Music.destroy_album!(album, authorize?: false)

      # notifications = Notification.read!()

      # assert length(notifications) == 1
      # assert Enum.map(notifications, & &1.id) == [to_stay_id]
    end

    @tag skip: "can be enabled during chapter 9"
    test "sends pubsub notifications about the notification deletion" do
      # follower = generate(user())
      # album = generate(album())
      # %{id: notification_id} = generate(notification(album_id: album.id, user_id: follower.id))
      # TunezWeb.Endpoint.subscribe("notifications:#{follower.id}:destroy")

      # Music.destroy_album!(album, authorize?: false)

      # assert_received %Phoenix.Socket.Broadcast{
      #   payload: %{data: %{id: ^notification_id}, action: %{name: :destroy}}
      # }
    end
  end

  describe "send_new_album_notifications" do
    @tag skip: "can be enabled during chapter 9"
    test "creates and sends notifications for followers of the album's artist" do
      # artist = generate(artist())
      # [follower, _nonfollower] = generate_many(user(), 2)
      # TunezWeb.Endpoint.subscribe("notifications:#{follower.id}:create")

      # Music.follow_artist!(artist, actor: follower)

      # %{id: album_id} = album = generate(album(artist_id: artist.id))

      # # Mimic running the action as an Oban job
      # album
      # |> Ash.Changeset.for_update(:send_new_album_notifications)
      # |> Ash.Changeset.put_context(:private, %{ash_oban?: true})
      # |> Ash.update!()

      # notifications = Notification.read!()
      # assert length(notifications) == 1
      # notification = hd(notifications)

      # assert notification.user_id == follower.id
      # assert notification.album_id == album.id
      # assert notification.dismissed_at == nil

      # assert_received(%Phoenix.Socket.Broadcast{
      #   payload: %{data: %{album_id: ^album_id}, action: %{name: :create}}
      # })
    end
  end

  describe "policies" do
    def setup_users do
      %{
        admin: generate(user(role: :admin)),
        editor: generate(user(role: :editor)),
        user: generate(user(role: :user))
      }
    end

    @tag :skip
    test "admins and editors can create new albums" do
      # users = setup_users()
      # assert Music.can_create_album?(users.admin)
      # assert Music.can_create_album?(users.editor)
      # refute Music.can_create_album?(users.user)
      # refute Music.can_create_album?(nil)
    end

    @tag :skip
    test "admins can delete albums" do
      # users = setup_users()
      # album = generate(album())

      # assert Music.can_destroy_album?(users.admin, album)
      # refute Music.can_destroy_album?(users.user, album)
      # refute Music.can_destroy_album?(nil, album)
    end

    @tag :skip
    test "admins can update albums" do
      # users = setup_users()
      # album = generate(album())

      # assert Music.can_update_album?(users.admin, album)
      # refute Music.can_update_album?(users.user, album)
      # refute Music.can_update_album?(nil, album)
    end

    @tag :skip
    test "editors can edit albums that they created" do
      # users = setup_users()
      # can_edit = generate(album(seed?: true, created_by: users.editor))
      # cant_edit = generate(album(seed?: true, created_by: users.admin))

      # assert Music.can_update_album?(users.editor, can_edit)
      # refute Music.can_update_album?(users.editor, cant_edit)
    end

    @tag :skip
    test "editors can delete albums that they created" do
      # users = setup_users()
      # can_delete = generate(album(seed?: true, created_by: users.editor))
      # cant_delete = generate(album(seed?: true, created_by: users.admin))

      # assert Music.can_destroy_album?(users.editor, can_delete)
      # refute Music.can_destroy_album?(users.editor, cant_delete)
    end
  end

  describe "validations" do
    @tag :skip
    test "year_released must be between 1950 and now" do
      # admin = generate(user(role: :admin))
      # artist = generate(artist())

      # assert Music.create_album!(
      #          %{artist_id: artist.id, name: "test 2024", year_released: 2024},
      #          actor: admin
      #        )

      # # Using `assert_raise`
      # assert_raise Ash.Error.Invalid, ~r/must be between 1950 and next year/, fn ->
      #   Music.create_album!(
      #     %{artist_id: artist.id, name: "test 1925", year_released: 1925},
      #     actor: admin
      #   )
      # end

      # # Using `assert_has_error`
      # # Also always test edge cases! Is 1950 included or excluded?
      # %{artist_id: artist.id, name: "test 1950", year_released: 1950}
      # |> Music.create_album(actor: admin)
      # |> assert_has_error(Ash.Error.Invalid, fn
      #   %{message: message} ->
      #     message == "must be between 1950 and next year"

      #   _ ->
      #     false
      # end)
    end

    @tag :skip
    test "cover_image_url must be either a remote URL or a local URL from /images" do
      # admin = generate(user(role: :admin))
      # artist = generate(artist())

      # with_url = fn url ->
      #   Ash.Generator.action_input(Tunez.Music.Album, :create,
      #     artist_id: artist.id,
      #     year_released: 2025,
      #     cover_image_url: url
      #   )
      #   |> Enum.at(0)
      # end

      # assert Music.create_album!(with_url.("/images/test.jpg"), actor: admin)

      # assert_raise Ash.Error.Invalid, ~r/must start with/, fn ->
      #   Music.create_album!(with_url.("notavalidURL"), actor: admin)
      # end

      # with_url.("/image/tunez.mp3")
      # |> Music.create_album(actor: admin)
      # |> assert_has_error(fn error ->
      #   error.field == :cover_image_url && error.message == "must start with https:// or /images/"
      # end)
    end
  end
end
