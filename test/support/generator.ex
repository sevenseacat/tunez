defmodule Tunez.Generator do
  @moduledoc "Data generation for tests"

  use Ash.Generator

  @doc """
  Generates album changesets using the `:create` action.

  ## Extra Options

  - `:actor` - Specify the actor creating the album OR
  - `:actor_role` - Specify the role to give to the generated actor.
    Defaults to `:editor`.

  - `:artist_id` - Specify the artist ID for the album.
  - `:track_count` - The number of tracks to generate for the album.
  """
  def album(opts \\ []) do
    raise "Uncomment the `album` generator content in `test/support/generator.ex` (and remove this line)"
    # actor =
    #   opts[:actor] ||
    #     once(:default_actor, fn ->
    #       generate(user(role: opts[:actor_role] || :editor))
    #     end)

    # artist_id =
    #   opts[:artist_id] ||
    #     once(:default_artist_id, fn ->
    #       generate(artist()).id
    #     end)

    # after_action =
    #   if opts[:track_count] do
    #     fn album ->
    #       generate_many(track(album_id: album.id), opts[:track_count])
    #       Ash.load!(album, :tracks)
    #     end
    #   end

    # if opts[:seed?] do
    #   seed_generator(
    #     %Tunez.Music.Album{
    #       name: sequence(:album_name, &"Album #{&1}"),
    #       year_released: StreamData.integer(1951..2024),
    #       artist_id: artist_id
    #     },
    #     actor: actor,
    #     overrides: opts,
    #     after_action: after_action
    #   )
    # else
    #   changeset_generator(
    #     Tunez.Music.Album,
    #     :create,
    #     defaults: [
    #       name: sequence(:album_name, &"Album #{&1}"),
    #       year_released: StreamData.integer(1951..2024),
    #       artist_id: artist_id,
    #       cover_image_url: nil
    #     ],
    #     overrides: opts,
    #     actor: actor,
    #     after_action: after_action
    #   )
    # end
  end

  @doc """
  Generates artist changesets with the `:create` action.

  ## Extra Options

  - `:actor` - Specify the actor to create the record
  - `:seed?` - If present, will seed data instead of using actions to insert data
  - `:album_count` - The number of albums to generate for the artist
  """
  def artist(opts \\ []) do
    raise "Uncomment the `artist` generator content in `test/support/generator.ex` (and remove this line)"
    # actor =
    #   opts[:actor] ||
    #     once(:default_actor, fn ->
    #       generate(user(role: :admin))
    #     end)

    # after_action =
    #   if opts[:album_count] do
    #     fn artist ->
    #       generate_many(album(artist_id: artist.id), opts[:album_count])
    #       Ash.load!(artist, :albums)
    #     end
    #   end

    # if opts[:seed?] do
    #   seed_generator(
    #     %Tunez.Music.Artist{name: sequence(:artist_name, &"Artist #{&1}")},
    #     actor: actor,
    #     overrides: opts,
    #     after_action: after_action
    #   )
    # else
    #   changeset_generator(
    #     Tunez.Music.Artist,
    #     :create,
    #     defaults: [name: sequence(:artist_name, &"Artist #{&1}")],
    #     actor: actor,
    #     overrides: opts,
    #     after_action: after_action
    #   )
    # end
  end

  @doc """
  Generates notification changesets with the `:create` action.

  ## Extra Options

  - `:user_id` - Specify the user ID for the notification
  - `:album_id` - Specify the album ID for the notification
  """
  def notification(opts \\ []) do
    raise "Uncomment the `notification` generator content in `test/support/generator.ex` (and remove this line)"
    # user_id = opts[:user_id] || once(:default_user_id, fn -> generate(user()).id end)
    # album_id = opts[:album_id] || once(:default_album_id, fn -> generate(album()).id end)

    # changeset_generator(
    #   Tunez.Accounts.Notification,
    #   :create,
    #   overrides: %{user_id: user_id, album_id: album_id}
    # )
  end

  @doc """
  Generates track changesets with the `:create` action.

  ## Extra Options

  - `:actor` - Specify the actor to create the record
  - `:album_id` - Specify the album ID for the track

  """
  def track(opts \\ []) do
    raise "Uncomment the `track` generator content in `test/support/generator.ex` (and remove this line)"
    # actor = opts[:actor] || once(:default_actor, fn -> generate(user(role: :admin)) end)
    # album_id = opts[:album_id] || once(:default_album_id, fn -> generate(album()).id end)

    # changeset_generator(
    #   Tunez.Music.Track,
    #   :create,
    #   defaults: [
    #     album_id: album_id,
    #     number: sequence(:track_number, &(&1 + 1)),
    #     duration:
    #       StreamData.repeatedly(fn ->
    #         "#{Enum.random(1..20)}:#{Enum.random(0..5)}#{Enum.random(0..9)}"
    #       end)
    #   ],
    #   overrides: opts,
    #   actor: actor
    # )
  end

  @doc """
  Generates user changesets with the `:register_with_password` action.

  ## Extra Options

  - `:role` - Specify a role to give the created user. Defaults to `:user`.
  """
  def user(opts \\ []) do
    raise "Uncomment the `user` generator content in `test/support/generator.ex` (and remove this line)"
    # changeset_generator(
    #   Tunez.Accounts.User,
    #   :register_with_password,
    #   defaults: [
    #     # Generates unique values using an auto-incrementing sequence
    #     # eg. `user1@example.com`, `user2@example.com`, etc.
    #     email: sequence(:user_email, &"user#{&1}@example.com"),
    #     password: "password",
    #     password_confirmation: "password"
    #   ],
    #   overrides: opts,
    #   after_action: fn user ->
    #     role = opts[:role] || :user
    #     Tunez.Accounts.set_user_role!(user, role, authorize?: false)
    #   end
    # )
  end
end
