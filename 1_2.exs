list_of_numbers = File.read!("data/1.txt")
|> String.split("\n", trim: true)

Stream.cycle(list_of_numbers)
|> Enum.reduce_while({0, MapSet.new([0])}, fn(number, {acc, seen_frequencies}) ->
  frequency_change = String.to_integer(number)
  new_frequency = acc + frequency_change

  case MapSet.member?(seen_frequencies, new_frequency) do
    true ->
      {:halt, new_frequency}
    false ->
      updated_set = MapSet.put(seen_frequencies, new_frequency)
      {:cont, {new_frequency, updated_set}}
  end
end)
|> IO.puts()
