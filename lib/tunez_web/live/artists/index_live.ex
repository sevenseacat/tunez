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
    <Layouts.app {assigns}>
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
        <.icon name="hero-face-frown" class="w-32 h-32 bg-gray-300" />
        <br /> No artist data to display!
      </div>

      <ul class="gap-6 lg:gap-12 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4">
        <li :for={artist <- @artists}>
          <.artist_card artist={artist} />
        </li>
      </ul>
    </Layouts.app>
    """
  end

  def artist_card(assigns) do
    ~H"""
    <div id={"artist-#{@artist.id}"} data-role="artist-card" class="relative mb-2">
      <.link navigate={~p"/artists/#{@artist.id}"}>
        <.cover_image />
      </.link>
    </div>
    <p class="flex justify-between">
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

  def follow_icon(assigns) do
    ~H"""
    <.icon name="hero-star-solid" class="w-8 h-8 bg-yellow-400 absolute top-2 right-2" />
    """
  end

  def follower_count_display(assigns) do
    ~H"""
    <span
      :if={@count > 0}
      data-role="follower-count"
      class="text-zinc-500 text-sm whitespace-nowrap pt-1 pl-1"
    >
      <.icon name="hero-star" class="size-4 -mt-0.5" /> {round_count(@count)}
    </span>
    """
  end

  def pagination_links(assigns) do
    ~H"""
    <div class="flex justify-center pt-8 space-x-4">
      <.button_link data-role="previous-page" kind="primary" inverse>
        « Previous
      </.button_link>
      <.button_link data-role="next-page" kind="primary" inverse>
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
      <.icon name="hero-magnifying-glass" class="w-4 h-4 m-2 ml-3 mt-4 absolute bg-gray-400" />
      <label for="search-text" class="hidden">Search</label>
      <.input
        class="!rounded-full p-1 pl-8 !w-32 sm:!w-48"
        name="query"
        id="search-text"
        value={@query}
      />
      {render_slot(@inner_block)}
    </form>
    """
  end

  def sort_changer(assigns) do
    assigns = assign(assigns, :options, sort_options())

    ~H"""
    <form data-role="artist-sort" class="hidden sm:inline" phx-change="change-sort">
      <.input
        label="sort by:"
        type="select"
        id="sort_by"
        name="sort_by"
        options={@options}
        value={@selected}
        class="px-2 py-0.5 !w-fit !inline-block pr-8 text-sm"
        container_class="!inline-block"
      />
    </form>
    """
  end

  defp sort_options do
    [
      {"recently updated", "updated_at"},
      {"recently added", "inserted_at"},
      {"name", "name"}
    ]
  end

  def validate_sort_by(key) do
    valid_keys = Enum.map(sort_options(), &elem(&1, 1))

    if key in valid_keys do
      key
    else
      List.first(valid_keys)
    end
  end

  defp remove_empty(params) do
    Enum.filter(params, fn {_key, val} -> val != "" end)
  end

  def handle_event("change-sort", %{"sort_by" => sort_by}, socket) do
    params = remove_empty(%{q: socket.assigns.query_text, sort_by: sort_by})
    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  def handle_event("search", %{"query" => query}, socket) do
    params = remove_empty(%{q: query})
    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  def round_count(number) do
    case number do
      n when n >= 1_000_000 -> "#{Float.round(n / 1_000_000, 1)}M"
      n when n >= 1_000 -> "#{Float.round(n / 1_000, 1)}K"
      n -> n
    end
  end
end
