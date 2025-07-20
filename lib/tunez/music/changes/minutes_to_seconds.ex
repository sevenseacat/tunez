defmodule Tunez.Music.Changes.MinutesToSeconds do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    {:ok, duration} = Ash.Changeset.fetch_argument(changeset, :duration)

    with :ok <- ensure_valid_format(duration),
         :ok <- ensure_valid_value(duration) do
      changeset
      |> Ash.Changeset.change_attribute(:duration_seconds, to_seconds(duration))
    else
      {:error, :format} ->
        Ash.Changeset.add_error(changeset,
          field: :duration,
          message: "use MM:SS format"
        )

      {:error, :value} ->
        Ash.Changeset.add_error(changeset,
          field: :duration,
          message: "must be at least 1 second long"
        )
    end
  end

  defp ensure_valid_format(duration) do
    if String.match?(duration, ~r/^\d+:\d{2}$/) do
      :ok
    else
      {:error, :format}
    end
  end

  defp ensure_valid_value(v) when v in ["0:00", "00:00"], do: {:error, :value}
  defp ensure_valid_value(_value), do: :ok

  defp to_seconds(duration) do
    [minutes, seconds] = String.split(duration, ":", parts: 2)
    String.to_integer(minutes) * 60 + String.to_integer(seconds)
  end
end
