defmodule Adventofcode2018.SixTest do
  use ExUnit.Case

  test "finds largest area" do
    coordinates = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]

    Adventofcode2018.Six.find_largest(coordinates)
    |> IO.inspect()
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.into(%{})
    |> IO.inspect()
  end
end
