ids = File.read!("data/2.txt")
      |> String.split("\n")
      |> Enum.reject(& &1 == "")

Enum.reduce_while(ids, ids, fn(box_id, acc) ->
  differences = Enum.map(acc, fn(id) ->
    distance = String.jaro_distance(box_id, id)
    if distance > 0.974358974358974 && distance < 1.0 do
      {box_id, id}
    else
      nil
    end
  end)
  |> Enum.filter(& !is_nil(&1))

  if Enum.count(differences) > 0 do
    {:halt, differences}
  else
    {:cont, acc}
  end
end)
|> IO.inspect
