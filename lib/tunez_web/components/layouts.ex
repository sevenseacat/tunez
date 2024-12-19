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

  def user_info(assigns) do
    ~H"""
    <div class="space-x-3">
      <%= if @current_user do %>
        <.live_component module={TunezWeb.Notifications} id={:notifications} notifications={[]} />

        <div class="dropdown dropdown-end">
          <div tabindex="0" role="button" class="btn btn-link pr-0">
            <.avatar user={@current_user} />
          </div>
          <ul
            tabindex="0"
            class="menu menu-sm dropdown-content z-[1] p-2 shadow bg-base-100 rounded-box w-fit-content"
          >
            <li class="border-b border-base-200 mb-1 pb-1">
              <div>
                <p>
                  Signed in as <strong class="whitespace-nowrap">{@current_user.email}</strong>
                </p>
              </div>
            </li>
            <li><.link navigate="/sign-out">Sign out</.link></li>
          </ul>
        </div>
      <% else %>
        <.button_link navigate="/sign-in" size="xs" type="ghost">
          Sign In
        </.button_link>
        <span>or</span>
        <.button_link navigate="/register" size="xs" type="ghost">
          Register
        </.button_link>
      <% end %>
    </div>
    """
  end
end
