defmodule Adventofcode2018.Seven do
  import NimbleParsec

  instruction =
    ignore(string("Step "))
    |> ascii_char([?A..?Z])
    |> ignore(string(" must be finished before step "))
    |> ascii_char([?A..?Z])
    |> ignore(string(" can begin."))

  defparsecp(:instruction, instruction)

  @file_lines File.read!("data/7.txt")
              |> String.split("\n", trim: true)

  # prereq map is Step Key => Steps that needed Key done
  # postreq map is Step Key => Steps that Key needs done
  def instructions(lines) do
    Enum.reduce(lines, {%{}, %{}}, fn(line, {forward, backward}) ->
      {:ok, [prereq, postreq], _, _, _, _} = instruction(line)
      prereq = to_string([prereq])
      postreq = to_string([postreq])
      {Map.update(forward, prereq, [postreq], &([postreq | &1])), Map.update(backward, postreq, [prereq], &([prereq | &1]))}
    end)
  end

  def first do
    {prereqs, postreqs} = instructions(@file_lines)

    calculate_step_order(prereqs, postreqs)
  end

  def second do
    {prereqs, postreqs} = instructions(@file_lines)

    calculate_time(prereqs, postreqs)
  end

  def calculate_time(prereqs, postreqs, delay \\ 60, max_workers \\ 5) do
    all_steps = Map.keys(prereqs)
            |> Kernel.++(Map.keys(postreqs))
            |> Enum.uniq()
            |> Enum.sort()
            |> Enum.map(fn(step) ->
              [s] = String.to_charlist(step)
              {step, s + delay - 64}
            end)

    recursive_two(postreqs, max_workers, [], [], all_steps, -1)
  end

  def calculate_step_order(prereqs, postreqs) do
    all_steps = Map.keys(prereqs)
            |> Kernel.++(Map.keys(postreqs))
            |> Enum.uniq()
            |> Enum.sort()

    recursive(postreqs, [], all_steps)
  end

  defp recursive_two(_postreqs, _max_workers, _steps_done, [], [], n) do
    n
  end

  defp recursive_two(postreqs, max_workers, steps_done, steps_in_progress, steps_to_be_done, n) do
    {steps_in_progress, steps_done} = Enum.reduce(steps_in_progress, {[], steps_done}, fn({step, remaining}, {steps_in_progress, done}) ->
      case {step, remaining} do
        {step, 0} ->
          {steps_in_progress, [step | done]}
        {step, remaining} ->
          {[{step, remaining - 1} | steps_in_progress], done}
      end
    end)

    active = length(steps_in_progress)
    available = max_workers - active

    if available > 0 do
      {steps_in_progress, steps_to_be_done} =
        Enum.filter(steps_to_be_done, fn({step, _time}) ->
          required_steps = Map.get(postreqs, step)

          (required_steps == nil) || MapSet.subset?(MapSet.new(required_steps), MapSet.new(steps_done))
        end)
        |> Enum.sort()
        |> Enum.take(available)
        |> Enum.reduce({steps_in_progress, steps_to_be_done}, fn({step, time}, {steps_in_progress, steps_to_be_done}) ->
          steps_to_be_done = List.delete(steps_to_be_done, {step, time})
          {[{step, time - 1} | steps_in_progress], steps_to_be_done}
        end)

      recursive_two(postreqs, max_workers, steps_done, steps_in_progress, steps_to_be_done, n+1)
    else
      recursive_two(postreqs, max_workers, steps_done, steps_in_progress, steps_to_be_done, n+1)
    end
  end

  defp recursive(_postreqs, steps_done, []) do
    Enum.reverse(steps_done)
  end

  defp recursive(postreqs, steps_done, steps_to_be_done) do
    step_to_be_done =
      Enum.filter(steps_to_be_done, fn(step) ->
        required_steps = Map.get(postreqs, step)

        (required_steps == nil) || MapSet.subset?(MapSet.new(required_steps), MapSet.new(steps_done))
      end)
      |> Enum.sort()
      |> Enum.at(0)

    steps_done = [step_to_be_done | steps_done]
    steps_to_be_done = List.delete(steps_to_be_done, step_to_be_done)

    recursive(postreqs, steps_done, steps_to_be_done)
  end
end
