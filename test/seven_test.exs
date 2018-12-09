defmodule Adventofcode2018.SevenTest do
  use ExUnit.Case

  test "finds largest area" do
    instructions = [
      "Step C must be finished before step A can begin.",
      "Step C must be finished before step F can begin.",
      "Step A must be finished before step B can begin.",
      "Step A must be finished before step D can begin.",
      "Step B must be finished before step E can begin.",
      "Step D must be finished before step E can begin.",
      "Step F must be finished before step E can begin.",
    ]

    Adventofcode2018.Seven.instructions(instructions)
    |> IO.inspect()
  end

  test "part two" do
    instructions = [
      "Step C must be finished before step A can begin.",
      "Step C must be finished before step F can begin.",
      "Step A must be finished before step B can begin.",
      "Step A must be finished before step D can begin.",
      "Step B must be finished before step E can begin.",
      "Step D must be finished before step E can begin.",
      "Step F must be finished before step E can begin.",
    ]

    {prereqs, postreqs} = Adventofcode2018.Seven.instructions(instructions)
    Adventofcode2018.Seven.calculate_time(prereqs, postreqs, 0, 2)
    |> IO.inspect
  end
end
