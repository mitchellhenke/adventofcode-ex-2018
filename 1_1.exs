File.read!("data/1.txt")
|> String.split("\n")
|> Enum.reject(& &1 == "")
|> Enum.reduce(0, fn(number, acc) ->
  acc + String.to_integer(number)
end)
|> IO.puts()
