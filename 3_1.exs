File.read!("data/3.txt")
|> String.split("\n", trim: true)
|> Enum.reduce({MapSet.new, MapSet.new}, fn(row, {all_points, conflict_points}) ->
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

  {MapSet.union(all_points, positions), MapSet.union(conflict_points, MapSet.intersection(all_points, positions))}
end)
|> elem(1)
|> MapSet.size
|> IO.inspect()
