defmodule Aoc2023.Day3 do
  defp get_map(lines) do
    lines
    |> Enum.with_index(0)
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.graphemes()
      |> Enum.with_index(0)
      |> Enum.map(fn {c, col} -> {c, {col, row}} end)
    end)
  end

  defp get_symbol_positions(map) do
    map
    |> Enum.filter(fn {c, _} -> !Aoc2023.Util.Number.is_number?(c) && c != "." end)
    |> Enum.reduce(%{}, fn {c, pos}, acc ->
      Map.put(acc, pos, c)
    end)
  end

  def map_put_rec(map, idx, what) do
    new = Map.put(map, idx, what)

    with :error <- Map.fetch(new, idx - 1),
         true <- idx - 1 >= 0 do
      map_put_rec(new, idx - 1, what)
    else
      _ -> new
    end
  end

  defp get_number_positions(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.chunk_by(&Aoc2023.Util.Number.is_number?(&1))
      |> Enum.map(fn chunk ->
        if Aoc2023.Util.Number.is_number?(Enum.at(chunk, 0)) do
          chunk
          |> Enum.join("")
          |> Kernel.then(&{:num, &1})
        else
          chunk
          |> Enum.join("")
          |> String.length()
          |> Kernel.then(&{:gap, &1})
        end
      end)
      |> Enum.reduce([], fn el, acc ->
        idx =
          case acc do
            [] -> -1
            [{_, idx} | _] -> idx
          end

        case el do
          {:num, n} ->
            [{n, String.length(n) + idx} | acc]

          {:gap, n} ->
            [{:gap, n + idx} | acc]
        end
      end)
      |> Enum.reverse()
      |> Enum.reduce(%{}, fn {what, idx}, acc ->
        map_put_rec(acc, idx, what)
      end)
    end)
    |> Enum.with_index(0)
    |> Enum.reduce(%{}, fn {map, row}, acc ->
      Map.put(acc, row, map)
    end)
  end

  defp neighbours_of(col, row) do
    [
      [
        {col - 1, row - 1},
        {col, row - 1},
        {col + 1, row - 1}
      ],
      [{col - 1, row}],
      [{col + 1, row}],
      [
        {col - 1, row + 1},
        {col, row + 1},
        {col + 1, row + 1}
      ]
    ]
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day3.in", trim: true)
    map = get_map(input)
    symbol_positions = get_symbol_positions(map)
    number_positions = get_number_positions(input)

    symbol_positions
    |> Enum.flat_map(fn {{c, r}, _} ->
      neighbours_of(c, r)
      |> Enum.flat_map(fn neighbouring_tiles ->
        neighbouring_tiles
        |> Enum.map(fn {col, row} ->
          number_positions
          |> Map.get(row, %{})
          |> Map.get(col, :gap)
        end)
        |> Kernel.then(fn list ->
          case list do
            [_, :gap, _] -> list
            [x, x, :gap] -> [x]
            [:gap, x, x] -> [x]
            [x, x, x] -> [x]
            _ -> list
          end
        end)
      end)
      |> Enum.filter(&(&1 != :gap))
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.sum()
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day3.in", trim: true)

    map = get_map(input)

    symbol_positions =
      get_symbol_positions(map)
      |> Enum.filter(fn {_, c} -> c == "*" end)

    number_positions = get_number_positions(input)

    symbol_positions
    |> Enum.map(fn {{c, r}, _} ->
      neighbours_of(c, r)
      |> Enum.flat_map(fn neighbouring_tiles ->
        neighbouring_tiles
        |> Enum.map(fn {col, row} ->
          number_positions
          |> Map.get(row, %{})
          |> Map.get(col, :gap)
        end)
        |> Kernel.then(fn list ->
          case list do
            [_, :gap, _] -> list
            [x, x, :gap] -> [x]
            [:gap, x, x] -> [x]
            [x, x, x] -> [x]
            _ -> list
          end
        end)
      end)
      |> Enum.filter(&(&1 != :gap))
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(fn gear ->
      case gear do
        [_, _] -> true
        _ -> false
      end
    end)
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end
end
