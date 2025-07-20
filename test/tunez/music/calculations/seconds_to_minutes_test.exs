defmodule Tunez.Music.Calculations.SecondsToMinutesTest do
  use Tunez.DataCase, async: true

  test "can convert seconds to minutes and seconds" do
    [{144, "2:24"}, {215, "3:35"}, {600, "10:00"}, {22, "0:22"}, {5421, "90:21"}]
    |> Enum.each(fn {seconds, minutes} ->
      result = Ash.calculate!(Tunez.Music.Track, :duration, refs: %{duration_seconds: seconds})
      assert result == minutes
    end)
  end
end
