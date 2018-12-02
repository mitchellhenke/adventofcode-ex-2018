File.read!("data/2.txt")
|> String.split("\n")
|> Enum.reject(& &1 == "")
|> Enum.reduce(%{two: 0, three: 0}, fn(box_id, acc) ->
  letters = String.graphemes(box_id)
  unique = MapSet.new(letters)

  counted_letters = Enum.reduce_while(unique, MapSet.new, fn(letter, acc) ->
    count = Enum.count(letters, & &1 == letter)

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
|> IO.inspect()
