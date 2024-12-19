defmodule TunezWeb.Albums.FormLive do
  use TunezWeb, :live_view

  def mount(_params, _session, socket) do
    form = %{}

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:page_title, "New Album")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <.h1>{@page_title}</.h1>
    </.header>

    <.simple_form
      :let={form}
      id="album_form"
      as={:form}
      for={@form}
      phx-change="validate"
      phx-submit="save"
    >
      <.input name="artist_id" label="Artist" value="" disabled />
      <div class="sm:flex gap-8 space-y-8 md:space-y-0">
        <div class="sm:w-3/4"><.input field={form[:name]} label="Name" /></div>
        <div class="sm:w-1/4">
          <.input field={form[:year_released]} label="Year Released" type="number" />
        </div>
      </div>
      <.input field={form[:cover_image_url]} label="Cover Image URL" />

      <:actions>
        <.button type="primary">Save</.button>
      </:actions>
    </.simple_form>
    """
  end

  def track_inputs(assigns) do
    ~H"""
    <.h2>Tracks</.h2>

    <table class="table">
      <thead>
        <tr>
          <th class="px-0">Number</th>
          <th>Name</th>
          <th class="px-0" colspan="2">Duration (M:SS)</th>
        </tr>
      </thead>
      <tbody>
        <.inputs_for :let={track_form} field={@form[:tracks]}>
          <tr>
            <td class="align-top px-0 w-20">
              <.input field={track_form[:number]} type="number" />
            </td>
            <td class="align-top">
              <.input field={track_form[:name]} />
            </td>
            <td class="align-top px-0 w-24">
              <.input field={track_form[:duration]} />
            </td>
            <td class="align-top w-12 pt-5">
              <.button_link
                phx-click="remove-track"
                phx-value-path={track_form.name}
                kind="error"
                size="xs"
                text
                class="mt-0.5"
              >
                <.icon name="hero-trash" class="w-5 h-5" />
              </.button_link>
            </td>
          </tr>
        </.inputs_for>
      </tbody>
    </table>

    <.button_link phx-click="add-track" kind="primary" size="sm" outline>
      Add Track
    </.button_link>
    """
  end

  def handle_event("validate", %{"form" => _form_data}, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"form" => _form_data}, socket) do
    {:noreply, socket}
  end
end
