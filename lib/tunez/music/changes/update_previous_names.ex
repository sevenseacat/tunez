defmodule Tunez.Music.Changes.UpdatePreviousNames do
  use Ash.Resource.Change

  @impl true
  def atomic(_changeset, _opts, _context) do
    {:atomic,
     %{
       previous_names:
         {:atomic,
          expr(
            fragment(
              "array_remove(array_prepend(?, ?), ?)",
              name,
              previous_names,
              ^atomic_ref(:name)
            )
          )}
     }}
  end
end
