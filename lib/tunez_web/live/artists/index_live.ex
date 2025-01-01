defmodule TunezWeb.Artists.IndexLive do
  use TunezWeb, :live_view

  require Logger

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Artists")

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    query_text = Map.get(params, "q", "")
    artists = Tunez.Music.search_artists!(query_text)

    socket =
      socket
      |> assign(:query_text, query_text)
      |> assign(:artists, artists)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header responsive={false}>
      <.h1>Artists</.h1>
      <:action>
        <.search_box query={@query_text} method="get" data-role="artist-search" phx-submit="search" />
      </:action>
      <:action>
        <.button_link navigate={~p"/artists/new"} kind="primary">
          New Artist
        </.button_link>
      </:action>
    </.header>

    <div :if={@artists == []} class="p-8 text-center">
      <.icon name="hero-face-frown" class="w-32 h-32 bg-base-300" />
      <br /> No artist data to display!
    </div>

    <ul class="gap-6 lg:gap-12 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4">
      <li :for={artist <- @artists}>
        <.artist_card artist={artist} />
      </li>
    </ul>
    """
  end

  def artist_card(assigns) do
    ~H"""
    <div id={"artist-#{@artist.id}"} data-role="artist-card" class="relative mb-2">
      <.link navigate={~p"/artists/#{@artist.id}"}>
        <.cover_image />
      </.link>
    </div>
    <p>
      <.link
        navigate={~p"/artists/#{@artist.id}"}
        class="text-lg font-semibold"
        data-role="artist-name"
      >
        {@artist.name}
      </.link>
    </p>
    """
  end

  def artist_card_album_info(%{artist: %{album_count: 0}} = assigns), do: ~H""

  def artist_card_album_info(assigns) do
    ~H"""
    <span class="mt-2 text-sm leading-6 text-zinc-500">
      {@artist.album_count} {ngettext("album", "albums", @artist.album_count)},
      latest release {@artist.latest_album_year_released}
    </span>
    """
  end

  def pagination_links(assigns) do
    ~H"""
    <div class="flex justify-center pt-8 join">
      <.button_link data-role="previous-page" class="join-item" kind="primary" outline>
        « Previous
      </.button_link>
      <.button_link data-role="next-page" class="join-item" kind="primary" outline>
        Next »
      </.button_link>
    </div>
    """
  end

  attr :query, :string, default: ""
  attr :rest, :global, include: ~w(method action phx-submit data-role)
  slot :inner_block, required: false

  def search_box(assigns) do
    ~H"""
    <form class="relative w-fit inline-block" {@rest}>
      <.icon name="hero-magnifying-glass" class="w-4 h-4 m-2 ml-3 absolute bg-base-content/50" />
      <input
        class="input input-bordered rounded-full input-sm pl-8 w-32 sm:w-48"
        name="query"
        value={@query}
      />
      {render_slot(@inner_block)}
    </form>
    """
  end

  def sort_changer(assigns) do
    assigns = assign(assigns, :options, sort_options())

    ~H"""
    <form data-role="artist-sort" class="hidden sm:inline" phx-change="change_sort">
      <label for="sort_by" class="text-sm">sort by:</label>
      <select class="select select-bordered select-sm py-0 w-fit" name="sort_by">
        <option
          :for={{value, text} <- @options}
          value={value}
          {if @selected == value, do: [selected: true], else: []}
        >
          {text}
        </option>
      </select>
    </form>
    """
  end

  defp sort_options do
    [
      {"updated_at", "recently updated"},
      {"inserted_at", "recently added"},
      {"name", "name"}
    ]
  end

  def validate_sort_by(key) do
    valid_keys = Enum.map(sort_options(), &elem(&1, 0))

    if key in valid_keys do
      key
    else
      List.first(valid_keys)
    end
  end

  defp remove_empty(params) do
    Enum.filter(params, fn {_key, val} -> val != "" end)
  end

  def handle_event("change_sort", %{"sort_by" => sort_by}, socket) do
    params = remove_empty(%{q: socket.assigns.query_text, sort_by: sort_by})
    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  def handle_event("search", %{"query" => query}, socket) do
    params = remove_empty(%{q: query})
    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end
end
