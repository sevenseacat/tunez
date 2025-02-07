defmodule Tunez.Music.Changes.MinutesToSeconds do
  use Ash.Resource.Change

  def change(changeset, _opts, _context) do
    {:ok, duration} = Ash.Changeset.fetch_argument(changeset, :duration)

    if String.match?(duration, ~r/^\d+:\d{2}$/) do
      changeset
      |> Ash.Changeset.change_attribute(:duration_seconds, to_seconds(duration))
    else
      changeset
      |> Ash.Changeset.add_error(field: :duration, message: "use MM:SS format")
    end
  end

  defp to_seconds(duration) do
    [minutes, seconds] = String.split(duration, ":", parts: 2)
    String.to_integer(minutes) * 60 + String.to_integer(seconds)
  end
end
