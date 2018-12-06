defmodule Adventofcode2018.Five do
  @letters File.read!("data/5.txt")
           |> String.trim()

  def first do
    String.graphemes(@letters)
    |> process_letters([])
  end

  def second do
    @letters
    |> String.downcase()
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.map(fn letter ->
      {:ok, regex} = Regex.compile(letter, "i")

      processed =
        Regex.replace(regex, @letters, "")
        |> String.graphemes()
        |> process_letters([])

      {letter, processed, Enum.count(processed)}
    end)
  end

  def process_letters(letters, acc), do: process_letters(letters, acc, false)

  def process_letters([first | [second | rest]], acc, have_replaced) do
    if String.downcase(first) == String.downcase(second) && first != second do
      process_letters(rest, acc, true)
    else
      process_letters([second | rest], [first | acc], have_replaced)
    end
  end

  def process_letters([next | rest], acc, have_replaced) do
    process_letters(rest, [next | acc], have_replaced)
  end

  def process_letters([], acc, true) do
    Enum.reverse(acc)
    |> process_letters([], false)
  end

  def process_letters([], acc, false) do
    Enum.reverse(acc)
  end
end
