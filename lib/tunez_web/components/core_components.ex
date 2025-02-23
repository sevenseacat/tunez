defmodule TunezWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  use TunezWeb, :verified_routes

  alias Phoenix.LiveView.JS
  use Gettext, backend: TunezWeb.Gettext

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil

  attr :kind, :atom,
    values: [:warning, :info, :error],
    doc: "used for styling and flash lookup"

  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "relative",
        "w-80 sm:w-96 shadow-lg mb-2 border-0 border-l-4 bg-white cursor-pointer rounded-lg p-4",
        @kind == :info && "border-green-600",
        @kind == :error && "border-error-600",
        @kind == :warning && "border-yellow-500"
      ]}
      {@rest}
    >
      <div class="grid grid-flow-cols grid-cols-[auto_minmax(auto,1fr)] justify-items-start text-start gap-2 items-center">
        <.icon
          :if={@kind == :error}
          name="hero-exclamation-circle-mini"
          class="w-6 h-6 text-error-600"
        />
        <.icon :if={@kind == :info} name="hero-check-circle-mini" class="w-6 h-6 text-green-600" />
        <.icon
          :if={@kind == :warning}
          name="hero-exclamation-circle-mini"
          class="w-6 h-6 text-yellow-500"
        />
        <div>
          <p :if={@title} class="font-semibold text-sm">{@title}</p>
          <p class="text-sm">{msg}</p>
        </div>
        <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
          <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} class="fixed top-4 right-4 space-y-2 z-50">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />
      <.flash kind={:warning} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        {gettext("Hang in there while we get back on track")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  slot :inner_block

  def h1(assigns) do
    ~H"""
    <h1 class="text-3xl font-semibold leading-8 py-2">
      {render_slot(@inner_block)}
    </h1>
    """
  end

  slot :inner_block

  def h2(assigns) do
    ~H"""
    <h2 class="text-xl font-semibold">
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :image, :string, default: nil

  def cover_image(assigns) do
    ~H"""
    <%= if @image do %>
      <img src={@image} class="block aspect-square rounded-md w-full" />
    <% else %>
      <div class="border border-gray-300 place-content-center grid rounded-md aspect-square">
        <.icon name="hero-photo" class="bg-gray-300 w-8 h-8" />
      </div>
    <% end %>
    """
  end

  attr :kind, :string,
    values: ~w(base primary error),
    default: "base"

  attr :inverse, :boolean, default: false
  attr :size, :string, values: ~w(sm xs md), default: "md"
  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(navigate disabled patch)

  slot :inner_block

  def button_link(assigns) do
    assigns =
      assign(assigns, :theme, button_styles(assigns.kind, assigns.inverse, assigns.size))

    ~H"""
    <.link
      class={[
        @theme,
        @rest[:disabled] && "opacity-60 grayscale pointer-events-none",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def button_styles(kind, inverse, size) do
    theme =
      case {kind, inverse} do
        {"base", false} ->
          "bg-gray-100"

        {"base", true} ->
          "border border-gray-500 text-gray-600"

        {"primary", false} ->
          "bg-primary-600 hover:bg-primary-700 text-white"

        {"primary", true} ->
          "border border-primary-700 text-primary-700 hover:bg-primary-50 font-semibold"

        {"error", false} ->
          "bg-error-700 hover:bg-error-800 text-white"

        {"error", true} ->
          "text-error-600 underline"

        _ ->
          ""
      end

    [
      "phx-submit-loading:opacity-75 rounded-lg font-medium leading-none inline-block",
      size == "md" && "py-3 px-5 text-sm",
      size == "sm" && "py-2 px-3 text-sm",
      size == "xs" && "py-2 px-2 text-xs",
      theme
    ]
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-8">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={
        [
          "phx-submit-loading:opacity-75 rounded-lg font-medium leading-none",
          # medium
          "py-3 px-4 text-sm",
          # primary
          "bg-primary-600 hover:bg-primary-700 text-white",
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any
  attr :class, :string, default: "", doc: "Any extra classes to be applied"
  attr :container_class, :string, default: "", doc: "Classes to be applied to the parent div"

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <.form_control class={@container_class} errors={@errors}>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class={[form_input_styles(), @class]}
          {@rest}
        />
        {@label}
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </.form_control>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <.form_control class={@container_class} errors={@errors}>
      <.label for={@id}>{@label}</.label>
      <select id={@id} name={@name} class={[form_input_styles(), @class]} multiple={@multiple} {@rest}>
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{msg}</.error>
    </.form_control>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <.form_control class={@container_class} errors={@errors}>
      <.label for={@id}>{@label}</.label>
      <textarea id={@id} name={@name} class={[form_input_styles(), @class, "min-h-[6rem]"]} {@rest}><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}>{msg}</.error>
    </.form_control>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <.form_control class={@container_class} errors={@errors}>
      <.label for={@id}>{@label}</.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[form_input_styles(), @class]}
        phx-debounce="250"
        {@rest}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </.form_control>
    """
  end

  def form_input_styles do
    [
      "my-2 block w-full rounded-lg text-zinc-900 focus:ring focus:outline-none sm:leading-6",
      "border-zinc-300 focus:border-zinc-400 focus:ring-zinc-100",
      "error:border-error-400 error:focus:border-error-600 error:focus:ring-error-100",
      "disabled:bg-gray-100 disabled:text-zinc-400"
    ]
  end

  attr :errors, :list, default: []
  attr :class, :string, default: ""
  slot :inner_block

  def form_control(assigns) do
    ~H"""
    <div class={[@class, @errors != [] && "error"]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="text-sm font-medium leading-6 text-zinc-800 error:text-error-600">
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-1.5 flex gap-1.5 text-sm leading-6 text-error-600 items-center">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title and optionally some actions.

  At small screen sizes, any actions provided will collapse into a dropdown list.
  This can be disabled with `responsive={false}`.
  """
  attr :class, :string, default: nil
  attr :responsive, :boolean, default: true

  slot :inner_block, required: true
  slot :subtitle
  slot :action

  def header(assigns) do
    assigns = assign_new(assigns, :dropdown_id, fn -> "dropdown_#{Ecto.UUID.generate()}" end)

    ~H"""
    <header class={[
      @action != [] && "flex items-center justify-between sm:gap-3 md:gap-6",
      @class,
      "my-6"
    ]}>
      <div>
        {render_slot(@inner_block)}
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div
        :if={@action != []}
        class={[
          !@responsive && "flex-none",
          @responsive && "max-sm:relative sm:flex-none sm:space-x-4"
        ]}
      >
        <div
          :if={@responsive}
          tabindex="0"
          role="button"
          class={[button_styles("primary", true, "xs"), "sm:hidden"]}
          phx-click={toggle("##{@dropdown_id}")}
          phx-click-away={hide("##{@dropdown_id}")}
        >
          <.icon name="hero-chevron-double-down w-4 h-4" />
        </div>
        <div
          id={@dropdown_id}
          tabindex="0"
          class={[
            @responsive &&
              "max-sm:hidden max-sm:absolute max-sm:right-0 max-sm:bg-white max-sm:shadow max-sm:rounded sm:!block"
          ]}
        >
          <div class={[
            !@responsive && "space-x-4",
            @responsive &&
              "max-sm:flex max-sm:flex-col-reverse max-sm:p-2 max-sm:w-48 sm:space-x-4"
          ]}>
            {render_slot(@action)}
          </div>
        </div>
      </div>
    </header>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  attr :user, :any
  attr :class, :string, default: ""

  def avatar(assigns) do
    assigns = assign(assigns, :seed, avatar_seed(assigns.user))

    ~H"""
    <img
      class={["rounded-full size-8", @class]}
      src={"https://api.dicebear.com/9.x/shapes/svg?seed=#{@seed}"}
    />
    """
  end

  def avatar_seed(user) do
    email =
      to_string(user.email)
      |> String.trim()
      |> String.downcase()

    :crypto.hash(:sha256, email)
    |> Base.encode16(case: :lower)
  end

  def time_ago_in_words(datetime) do
    diff = DateTime.diff(DateTime.utc_now(), datetime)

    cond do
      diff <= 5 ->
        "now"

      diff <= 60 ->
        ngettext("%{num} second ago", "%{num} seconds ago", diff, num: diff)

      diff <= 3600 ->
        num = div(diff, 60)
        ngettext("%{num} minute ago", "%{num} minutes ago", num, num: num)

      diff <= 24 * 3600 ->
        num = div(diff, 3600)
        ngettext("%{num} hour ago", "%{num} hours ago", num, num: num)

      diff <= 7 * 24 * 3600 ->
        num = div(diff, 24 * 3600)
        ngettext("%{num} day ago", "%{num} days ago", num, num: num)

      diff <= 30 * 24 * 3600 ->
        num = div(diff, 7 * 24 * 3600)
        ngettext("%{num} week ago", "%{num} weeks ago", num, num: num)

      diff <= 365 * 24 * 3600 ->
        num = div(diff, 30 * 24 * 3600)
        ngettext("%{num} month ago", "%{num} months ago", num, num: num)

      true ->
        "over a year ago"
    end
  end

  ## JS Commands

  def toggle(js \\ %JS{}, selector) do
    JS.toggle(js,
      to: selector,
      time: 300,
      in:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"},
      out:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(TunezWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(TunezWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
