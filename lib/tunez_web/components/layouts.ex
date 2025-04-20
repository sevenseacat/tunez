defmodule TunezWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use TunezWeb, :controller` and
  `use TunezWeb, :live_view`.
  """
  use TunezWeb, :html

  embed_templates "layouts/*"

  def app(assigns) do
    ~H"""
    <div class="w-full max-w-6xl m-auto">
      <div class="flex items-center w-full p-4 pb-2 border-b-2 border-primary-600">
        <div class="flex-1 mr-4">
          <.link navigate={~p"/"}>
            <.icon
              name="hero-musical-note-solid"
              class="w-8 h-8 bg-accent-400 inline-block align-middle"
            />
            <span class="text-2xl font-bold text-accent-400 inline-block align-middle mb-1 ml-1">
              Tunez
            </span>
          </.link>
        </div>
        <.user_info current_user={@current_user} socket={@socket} />
      </div>
      <div class="px-4">
        <.flash_group flash={@flash} />

        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  def user_info(assigns) do
    ~H"""
    <div class="flex space-x-3 relative items-center">
      <%= if @current_user do %>
        {live_render(@socket, TunezWeb.NotificationsLive, sticky: true, id: :notifications_container)}

        <div class="!ml-8">
          <div
            tabindex="0"
            role="button"
            class="pr-0"
            phx-click={toggle("#user-menu")}
            phx-click-away={hide("#user-menu")}
          >
            <.avatar user={@current_user} />
          </div>
          <ul
            id="user-menu"
            tabindex="0"
            class="hidden z-[1] p-2 mt-3 shadow rounded-lg w-fit-content absolute right-0 bg-white text-sm"
          >
            <li class="border-b border-gray-300 p-2 pt-0">
              <p>
                Signed in as <strong class="whitespace-nowrap">{@current_user.email}</strong>
              </p>
            </li>
            <li class="p-2 pb-0"><.link navigate="/sign-out" class="block">Sign out</.link></li>
          </ul>
        </div>
      <% else %>
        <.button_link navigate="/sign-in" size="xs">
          Sign In
        </.button_link>
        <span>or</span>
        <.button_link navigate="/register" size="xs">
          Register
        </.button_link>
      <% end %>
    </div>
    """
  end
end
