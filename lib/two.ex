defmodule Adventofcode2018.Two do
  def first do
    File.read!("data/2.txt")
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{two: 0, three: 0}, fn box_id, acc ->
      letters = String.graphemes(box_id)
      unique = MapSet.new(letters)

      counted_letters =
        Enum.reduce_while(unique, MapSet.new(), fn letter, acc ->
          count = Enum.count(letters, &(&1 == letter))

          set = MapSet.put(acc, count)

          if MapSet.subset?(set, MapSet.new([2, 3])) do
            {:halt, set}
          else
            {:cont, set}
          end
        end)

      contains_two = MapSet.member?(counted_letters, 2)
      contains_three = MapSet.member?(counted_letters, 3)

      case {contains_two, contains_three} do
        {true, true} ->
          %{acc | two: acc.two + 1, three: acc.three + 1}

        {true, false} ->
          %{acc | two: acc.two + 1}

        {false, true} ->
          %{acc | three: acc.three + 1}

        _ ->
          acc
      end
    end)
  end

  def second do
    ids =
      File.read!("data/2.txt")
      |> String.split("\n", trim: true)

    Enum.reduce_while(ids, ids, fn box_id, acc ->
      differences =
        Enum.map(acc, fn id ->
          distance = String.jaro_distance(box_id, id)

          if distance > 0.974358974358974 && distance < 1.0 do
            {box_id, id}
          else
            nil
          end
        end)
        |> Enum.filter(&(!is_nil(&1)))

      if Enum.count(differences) > 0 do
        {:halt, differences}
      else
        {:cont, acc}
      end
    end)
  end
end
