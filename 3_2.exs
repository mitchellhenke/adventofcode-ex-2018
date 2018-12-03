all_claims = File.read!("data/3.txt")
             |> String.split("\n", trim: true)
             |> Enum.reduce(MapSet.new, fn(row, acc) ->
               [_num, point_and_size] = String.split(row, "@ ")
               [point, size] = String.split(point_and_size, ": ")

               [x, y] = String.split(point, ",")
                        |> Enum.map(& String.to_integer(&1))

               [width, height] = String.split(size, "x")
                                 |> Enum.map(& String.to_integer(&1))

               positions = Enum.reduce(y..y+height-1, MapSet.new, fn(y_position, acc_out) ->
                 Enum.reduce(x..x+width-1, acc_out, fn(x_position, acc) ->
                   MapSet.put(acc, [x_position, y_position])
                 end)
               end)


               MapSet.put(acc, positions)
             end)

Enum.reduce_while(all_claims, nil, fn(claim, acc) ->
  MapSet.delete(all_claims, claim)
  |> Enum.all?(fn(x) ->
    MapSet.intersection(claim, x) == MapSet.new
  end)
  |> case do
    true ->
      {:halt, claim}
    false ->
      {:cont, acc}
  end
end)
|> Enum.sort()
|> IO.inspect(limit: :infinity)
