defmodule TunezWeb.Components.Flash do
  alias TunezWeb.Components.Flash.Normal
  import Flashy

  def put_flash!(socket, type, message) do
    opts =
      Flashy.Normal.Options.new(
        dismiss_time: :timer.seconds(5),
        closable?: true
      )

    socket
    |> put_notification(Normal.new(type, message, opts))
  end
end
