defmodule TunezWeb.Components.Flash.Disconnected do
  @moduledoc false
  use TunezWeb, :component
  use Flashy.Disconnected

  import TunezWeb.Components.Flash.Normal, only: [the_flash: 1]

  attr :key, :string, required: true

  def render(assigns) do
    options = Flashy.Normal.Options.new(dismissible?: false, closable?: false)
    assigns = assign(assigns, :options, options)

    ~H"""
    <Flashy.Disconnected.render key={@key}>
      <.the_flash type={:warning} key={@key} options={@options} title="We can't find the internet">
        Attempting to reconnect <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.the_flash>
    </Flashy.Disconnected.render>
    """
  end
end
