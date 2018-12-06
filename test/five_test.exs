defmodule Adventofcode2018.FiveTest do
  use ExUnit.Case

  test "strips repeated characters" do
    result =
      String.graphemes("dabAcCaCBAcCcaDA")
      |> Adventofcode2018.Five.process_letters([], false)

    assert result == "dabCBAcaDA"
  end
end
