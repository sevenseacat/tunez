defmodule TunezWeb.Components.Flash.Normal do
  use TunezWeb, :component
  use Flashy.Normal, types: [:info, :success, :warning, :error]

  attr :key, :string, required: true
  attr :notification, Flashy.Normal, required: true
  attr :title, :string, default: nil

  def render(assigns) do
    ~H"""
    <Flashy.Normal.render key={@key} notification={@notification}>
      <.the_flash key={@key} type={@notification.type} options={@notification.options}>
        <%= @notification.message %>
      </.the_flash>
    </Flashy.Normal.render>
    """
  end

  attr :key, :string, required: true
  attr :type, :atom, required: true
  attr :title, :string, default: nil
  attr :options, Flashy.Normal.Options, required: true
  slot :inner_block

  def the_flash(assigns) do
    ~H"""
    <div
      {close_button_properties(@options, @key)}
      role="alert"
      class={[
        "flash-#{@type}",
        "relative w-80 sm:w-96 shadow-lg mb-2 alert border-0 border-l-4 bg-base-100",
        "grid-flow-col grid-cols-[auto_minmax(auto,1fr)] justify-items-start text-start",
        @type == :success && "border-success",
        @type == :error && "border-error",
        @type == :info && "border-info",
        @type == :warning && "border-warning"
      ]}
    >
      <.icon :if={@type == :info} name="hero-information-circle-mini" class="w-6 h-6 text-info" />
      <.icon :if={@type == :error} name="hero-exclamation-circle-mini" class="w-6 h-6 text-error" />
      <.icon :if={@type == :success} name="hero-check-circle-mini" class="w-6 h-6 text-success" />
      <.icon :if={@type == :warning} name="hero-exclamation-circle-mini" class="w-6 h-6 text-warning" />
      <div>
        <p :if={@title} class="font-semibold text-sm"><%= @title %></p>
        <p class="text-sm"><%= render_slot(@inner_block) %></p>
      </div>
      <button :if={@options.closable?} type="button" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 hover:opacity-70" />
      </button>
      <.progress_bar :if={@options.dismissible?} id={"#{@key}-progress"} />
    </div>
    """
  end

  attr :id, :string, required: true

  defp progress_bar(assigns) do
    ~H"""
    <div id={@id} class="absolute bottom-0 left-0 h-0.5 bg-black/10" style="width: 0%" />
    """
  end

  defp close_button_properties(%{closable?: true}, key) do
    ["phx-click": JS.exec("data-hide", to: "##{key}")]
  end

  defp close_button_properties(%{closable?: false}, _), do: []
end
