defmodule Adventofcode2018.Four do
  defstruct [:number, :asleep, :last_time]
  alias __MODULE__

  @regex ~r/\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+)\] (?<text>.*)/
  def first do
    minutes = process()

    {number, minute_count} =
      Enum.max_by(minutes, fn {_guard_number, minute_count} ->
        Map.values(minute_count)
        |> Enum.sum()
      end)

    {minute, _total} =
      Enum.max_by(minute_count, fn {_minute, total} ->
        total
      end)

    IO.inspect("Guard ##{number} slept the most overall. Mostly during minute #{minute}")

    String.to_integer(number) * minute
  end

  def second do
    minutes = process()

    {guard_number, minute_count} =
      Enum.max_by(minutes, fn {_guard_id, minute_count} ->
        Map.values(minute_count)
        |> Enum.max()
      end)

    Enum.sort_by(minute_count, fn {_minute, count} ->
      count * -1
    end)
    |> List.first()
    |> elem(0)
    |> Kernel.*(String.to_integer(guard_number))
  end

  defp process do
    {minutes, _final_state} =
      File.read!("data/4.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        captures = Regex.named_captures(@regex, row)

        {:ok, date} =
          NaiveDateTime.from_iso8601(
            "#{captures["year"]}-#{captures["month"]}-#{captures["day"]} #{captures["hour"]}:#{
              captures["minute"]
            }:00"
          )

        {captures["text"], date}
      end)
      |> Enum.sort_by(fn {_text, date} ->
        {date.year, date.month, date.day, date.hour, date.minute}
      end)
      |> Enum.reduce({%{}, %Four{}}, fn {text, date}, {map, state} ->
        cond do
          String.contains?(text, "begins shift") ->
            [_, _, number, _, _] = String.split(text, ["#", " "])

            {map, %Four{number: number, asleep: false, last_time: date}}

          text == "wakes up" ->
            map =
              if(state.number) do
                Enum.reduce(state.last_time.minute..(date.minute - 1), map, fn minute, acc ->
                  Map.update(acc, state.number, %{minute => 1}, fn map_value ->
                    Map.update(map_value, minute, 1, &(&1 + 1))
                  end)
                end)
              else
                map
              end

            {map, %Four{state | asleep: false, last_time: date}}

          text == "falls asleep" ->
            {map, %Four{state | asleep: true, last_time: date}}
        end
      end)

    minutes
  end
end
