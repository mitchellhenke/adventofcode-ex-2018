defmodule Adventofcode2018.Six do
  import NimbleParsec

  coordinate =
    integer(min: 1)
    |> ignore(string(", "))
    |> integer(min: 1)

  defparsecp(:coordinate, coordinate)

  @file_lines File.read!("data/6.txt")
              |> String.split("\n", trim: true)

  def first do
    coordinates = coordinates()

    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, fn {_x, y} -> y end)

    build_closest(coordinates, [{min_x, max_x}, {min_y, max_y}])
    |> Enum.reject(fn {_point, coordinates} ->
      Enum.any?(coordinates, fn {x, y} ->
        x == min_x || x == max_x || y == min_y || y == max_y
      end)
    end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.sort_by(fn {_k, v} ->
      v * -1
    end)
  end

  def second do
    coordinates = coordinates()

    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, fn {_x, y} -> y end)

    Enum.reduce(min_x..max_x, 0, fn x, acc ->
      Enum.reduce(min_y..max_y, acc, fn y, inner_acc ->
        if Enum.reduce(coordinates, 0, fn {c_x, c_y}, acc ->
             acc + manhattan_distance({x, y}, {c_x, c_y})
           end) < 10_000 do
          inner_acc + 1
        else
          inner_acc
        end
      end)
    end)
  end

  def build_closest(coordinates, [{min_x, max_x}, {min_y, max_y}]) do
    Enum.reduce(min_x..max_x, %{}, fn x, acc ->
      Enum.reduce(min_y..max_y, acc, fn y, inner_acc ->
        case closest_points(coordinates, {x, y}) do
          {[coordinate], _distance} ->
            Map.update(inner_acc, coordinate, [{x, y}], &[{x, y} | &1])

          {[_coordinate | _rest], _distance} ->
            inner_acc
        end
      end)
    end)
  end

  def coordinates do
    @file_lines
    |> Enum.map(fn line ->
      {:ok, [x, y], _, _, _, _} = coordinate(line)
      {x, y}
    end)
  end

  def closest_points(coordinates, {x, y}) do
    {list, distance} =
      Enum.reduce(coordinates, {[], 9000}, fn {c_x, c_y}, {list, min_distance} ->
        distance = manhattan_distance({c_x, c_y}, {x, y})

        cond do
          distance < min_distance ->
            {[{c_x, c_y}], distance}

          distance == min_distance ->
            {[{c_x, c_y} | list], distance}

          distance > min_distance ->
            {list, min_distance}
        end
      end)

    {list, distance}
  end

  def manhattan_distance({x, y}, {x2, y2}), do: abs(x - x2) + abs(y - y2)
end
