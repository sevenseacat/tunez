defmodule TunezWeb.NotificationsLive do
  use TunezWeb, :live_view

  def mount(_params, _session, socket) do
    notifications = []
    {:ok, assign(socket, notifications: notifications)}
  end

  def render(assigns) do
    ~H"""
    <div class="relative">
      <div
        phx-click={toggle("#notifications")}
        phx-click-away={hide("#notifications")}
        class="p-1 mt-1 cursor-pointer relative"
      >
        <.icon name="hero-bell-alert" class="w-8 h-8 bg-gray-400" />
        <span :if={@notifications != []} class="absolute flex h-3 w-3 top-0 right-0 mt-1 mr-1.5">
          <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error-600 opacity-75">
          </span>
          <span class="relative inline-flex rounded-full h-3 w-3 bg-error-600"></span>
        </span>
      </div>
      <div id="notifications" class="z-10 hidden absolute top-10 right-0 bg">
        <div :if={@notifications == []} class="p-2 shadow bg-white rounded-lg w-52">
          <.icon name="hero-check-circle" class="w-8 h-8 bg-green-500" />
          <span class="text-sm px-2">No new notifications!</span>
        </div>
        <ul
          :if={@notifications != []}
          tabindex="0"
          class="p-2 shadow bg-white rounded-lg w-80 text-sm space-y-4"
        >
          <li :for={notification <- @notifications}>
            <.link
              navigate={~p"/artists/#{notification.album.artist_id}/#album-#{notification.album_id}"}
              phx-click={
                JS.push("dismiss-notification", value: %{id: notification.id})
                |> hide("#notifications")
              }
              class="grid grid-flow-col gap-2 cursor-pointer px-3 py-1"
            >
              <p>
                The album <span class="font-bold">{notification.album.name}</span>
                has been added for {notification.album.artist.name}<br />
                <span class="text-xs opacity-60">{time_ago_in_words(notification.inserted_at)}</span>
              </p>
              <div class="h-16 w-16">
                <.cover_image image={notification.album.cover_image_url} />
              </div>
            </.link>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("dismiss-notification", %{"id" => _id}, socket) do
    {:noreply, socket}
  end
end
