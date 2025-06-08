defmodule TunezWeb.Artists.ShowLive do
  use TunezWeb, :live_view

  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => artist_id}, _url, socket) do
    artist =
      Tunez.Music.get_artist_by_id!(artist_id,
        load: [:followed_by_me, albums: [:duration, tracks: [:favorited_by_me]]],
        actor: socket.assigns.current_user
      )

    socket =
      socket
      |> assign(:artist, artist)
      |> assign(:page_title, artist.name)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.h1>
          {@artist.name}
          <.follow_toggle
            :if={Tunez.Music.can_follow_artist?(@current_user, @artist)}
            on={@artist.followed_by_me}
          />
        </.h1>
        <:subtitle :if={@artist.previous_names != []}>
          formerly known as: {Enum.join(@artist.previous_names, ", ")}
        </:subtitle>
        <:action :if={Tunez.Music.can_destroy_artist?(@current_user, @artist)}>
          <.button_link
            kind="error"
            inverse
            phx-click="destroy-artist"
            data-confirm={"Are you sure you want to delete #{@artist.name}?"}
          >
            Delete Artist
          </.button_link>
        </:action>
        <:action :if={Tunez.Music.can_update_artist?(@current_user, @artist)}>
          <.button_link navigate={~p"/artists/#{@artist.id}/edit"} kind="primary" inverse>
            Edit Artist
          </.button_link>
        </:action>
      </.header>
      <div class="mb-6">{formatted(@artist.biography)}</div>

      <.button_link
        :if={Tunez.Music.can_create_album?(@current_user)}
        navigate={~p"/artists/#{@artist.id}/albums/new"}
        kind="primary"
      >
        New Album
      </.button_link>

      <ul class="mt-10 space-y-6 md:space-y-10">
        <li :for={album <- @artist.albums}>
          <.album_details album={album} current_user={@current_user} />
        </li>
      </ul>
    </Layouts.app>
    """
  end

  def album_details(assigns) do
    ~H"""
    <div id={"album-#{@album.id}"} class="md:flex gap-8 group">
      <div class="mx-auto mb-6 md:mb-0 w-2/3 md:w-72 lg:w-96">
        <.cover_image image={@album.cover_image_url} />
      </div>
      <div class="flex-1">
        <.header class="pl-3 pr-2 !m-0">
          <.h2>
            {@album.name} ({@album.year_released})
            <span :if={@album.duration} class="text-base">({@album.duration})</span>
          </.h2>
          <:action :if={Tunez.Music.can_destroy_album?(@current_user, @album)}>
            <.button_link
              size="sm"
              inverse
              kind="error"
              data-confirm={"Are you sure you want to delete #{@album.name}?"}
              phx-click="destroy-album"
              phx-value-id={@album.id}
            >
              Delete
            </.button_link>
          </:action>
          <:action :if={Tunez.Music.can_update_album?(@current_user, @album)}>
            <.button_link size="sm" kind="primary" inverse navigate={~p"/albums/#{@album.id}/edit"}>
              Edit
            </.button_link>
          </:action>
        </.header>
        <.track_details tracks={@album.tracks} current_user={@current_user} />
      </div>
    </div>
    """
  end

  defp track_details(assigns) do
    ~H"""
    <table :if={@tracks != []} class="w-full mt-2 -z-10">
      <tr :for={track <- @tracks} class="border-t first:border-0 border-gray-100">
        <th class="whitespace-nowrap w-1 p-3">
          {String.pad_leading("#{track.number}", 2, "0")}.
        </th>
        <td class="p-3 flex items-center gap-2">
          <span
            :if={@current_user}
            phx-click="toggle-favorite"
            phx-value-track-id={track.id}
            role="button"
            class="cursor-pointer hover:scale-110 transition-transform"
          >
            <.icon
              name={if track.favorited_by_me, do: "hero-star-solid", else: "hero-star"}
              class="w-4 h-4 bg-yellow-400"
            />
          </span>
          {track.name}
        </td>
        <td class="whitespace-nowrap w-1 text-right p-2">{track.duration}</td>
      </tr>
    </table>
    <div :if={@tracks == []} class="p-8 text-center italic text-gray-400">
      <.icon name="hero-clock" class="w-12 h-12 bg-base-300" /> Track data coming soon....
    </div>
    """
  end

  defp formatted(nil), do: ""

  defp formatted(text) when is_binary(text) do
    text
    |> String.split("\n", trim: false)
    |> Enum.intersperse(Phoenix.HTML.raw({:safe, "<br/>"}))
  end

  def follow_toggle(assigns) do
    event =
      if assigns.on do
        JS.push("unfollow")
      else
        JS.push("follow")
        |> JS.transition("animate-spin")
      end

    assigns = assign(assigns, :event, event)

    ~H"""
    <span phx-click={@event} class="ml-3 inline-block">
      <.icon
        name={if @on, do: "hero-star-solid", else: "hero-star"}
        class="w-8 h-8 bg-yellow-400 -mt-1.5 cursor-pointer"
      />
    </span>
    """
  end

  def handle_event("destroy-artist", _params, socket) do
    case Tunez.Music.destroy_artist(socket.assigns.artist, actor: socket.assigns.current_user) do
      :ok ->
        socket =
          socket
          |> put_flash(:info, "Artist deleted successfully")
          |> push_navigate(to: ~p"/")

        {:noreply, socket}

      {:error, error} ->
        Logger.info("Could not delete artist '#{socket.assigns.artist.id}': #{inspect(error)}")

        socket =
          socket
          |> put_flash(:error, "Could not delete artist")

        {:noreply, socket}
    end
  end

  def handle_event("destroy-album", %{"id" => album_id}, socket) do
    case Tunez.Music.destroy_album(album_id, actor: socket.assigns.current_user) do
      :ok ->
        socket =
          socket
          |> update(:artist, fn artist ->
            Map.update!(artist, :albums, fn albums ->
              Enum.reject(albums, &(&1.id == album_id))
            end)
          end)
          |> put_flash(:info, "Album deleted successfully")

        {:noreply, socket}

      {:error, error} ->
        Logger.info("Could not delete album '#{album_id}': #{inspect(error)}")

        socket =
          socket
          |> put_flash(:error, "Could not delete album")

        {:noreply, socket}
    end
  end

  def handle_event("follow", _params, socket) do
    socket =
      case Tunez.Music.follow_artist(socket.assigns.artist, actor: socket.assigns.current_user) do
        {:ok, _} ->
          update(socket, :artist, fn artist ->
            %{artist | followed_by_me: true}
          end)

        {:error, _} ->
          put_flash(socket, :error, "Could not follow artist")
      end

    {:noreply, socket}
  end

  def handle_event("unfollow", _params, socket) do
    socket =
      case Tunez.Music.unfollow_artist(socket.assigns.artist, actor: socket.assigns.current_user) do
        :ok ->
          update(socket, :artist, fn artist ->
            %{artist | followed_by_me: false}
          end)

        {:error, _} ->
          put_flash(socket, :error, "Could not unfollow artist")
      end

    {:noreply, socket}
  end

  def handle_event("toggle-favorite", %{"track-id" => track_id}, socket) do
    # Only allow authenticated users to favorite tracks
    if socket.assigns.current_user do
      # Find the track and album containing it
      {album_index, track_index, track} = find_track_in_artist(socket.assigns.artist, track_id)

      socket =
        if track.favorited_by_me do
          # Unfavorite the track
          case Tunez.Music.unfavorite_track(track, actor: socket.assigns.current_user) do
            :ok ->
              update_track_favorite_status(socket, album_index, track_index, false)

            {:error, _} ->
              put_flash(socket, :error, "Could not unfavorite track")
          end
        else
          # Favorite the track
          case Tunez.Music.favorite_track(track, actor: socket.assigns.current_user) do
            {:ok, _} ->
              update_track_favorite_status(socket, album_index, track_index, true)

            {:error, _} ->
              put_flash(socket, :error, "Could not favorite track")
          end
        end

      {:noreply, socket}
    else
      {:noreply, put_flash(socket, :error, "You must be logged in to favorite tracks")}
    end
  end

  defp find_track_in_artist(artist, track_id) do
    Enum.with_index(artist.albums)
    |> Enum.find_value(fn {album, album_index} ->
      case Enum.find_index(album.tracks, &(&1.id == track_id)) do
        nil ->
          nil

        track_index ->
          track = Enum.at(album.tracks, track_index)
          {album_index, track_index, track}
      end
    end)
  end

  defp update_track_favorite_status(socket, album_index, track_index, favorited?) do
    update(socket, :artist, fn artist ->
      albums =
        List.update_at(artist.albums, album_index, fn album ->
          tracks =
            List.update_at(album.tracks, track_index, fn track ->
              %{track | favorited_by_me: favorited?}
            end)

          %{album | tracks: tracks}
        end)

      %{artist | albums: albums}
    end)
  end
end
