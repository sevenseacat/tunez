defmodule Tunez.Support.Helpers do
  require Ash.Query

  @doc """
  Generate a timestamp at the specified offset in the past.

  ## Examples

      iex> Tunez.Support.Helpers.time_ago(5, :second)
  """
  def ago(seconds, unit) when is_integer(seconds) do
    DateTime.utc_now()
    |> DateTime.add(-seconds, unit)
  end

  @doc """
  Fetch a record of the given resource by its `name` attribute.
  Will return at most one record, or nil.

  Any opts passed in as the third argument will be passed directly to
  the read action of the resource.

  ## Examples

      iex> Tunez.Support.Helpers.get_by_name(Tunez.Music.Artist, "Anderon")
  """
  def get_by_name(resource, name, opts \\ []) do
    resource
    |> Ash.Query.for_read(:read, %{}, opts)
    |> Ash.Query.filter(name == ^name)
    |> Ash.read_first!()
  end

  @doc """
  Fetch a record of the given resource by its `name` attribute.
  Will raise a RuntimeError if no record matches.

  The bang version of the `get_by_name` helper function.
  """
  def get_by_name!(resource, name, opts \\ []) do
    case get_by_name(resource, name, opts) do
      nil -> raise RuntimeError, "No results returned"
      result -> result
    end
  end

  # ------ Selectors --------------------------------------------------------

  @doc "HTML selector for flash messages."
  def flash(type), do: ":not(#server-error, #client-error) > div.flash-#{type}"

  def link(href), do: "a[href='#{href}']"

  def clickable(event_name, record \\ nil) do
    if record do
      "[phx-value-id='#{record.id}'][phx-click='#{event_name}']"
    else
      "[phx-click='#{event_name}']"
    end
  end
end
