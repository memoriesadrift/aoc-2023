defmodule Aoc2023.Day11 do
  defp taxicab_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp distances_to_galaxies(galaxies) do
    galaxies
    |> Enum.flat_map(fn galaxy ->
      Enum.map(galaxies, fn other_galaxy ->
        taxicab_distance(galaxy, other_galaxy)
      end)
    end)
    |> Enum.sum()
    |> div(2)
  end

  defp calc_galaxy_positions(input, spaces_to_insert) do
    base_map =
      input
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.with_index()
      |> Enum.map(fn {row, idx} -> {Enum.with_index(row), idx} end)
      |> Enum.reduce(%{}, fn {row, x}, acc ->
        row
        |> Enum.map(fn {val, y} ->
          {{x, y}, val}
        end)
        |> Enum.reduce(acc, fn {pos, val}, acc -> Map.put(acc, pos, val) end)
      end)

    base_rows =
      input
      |> Enum.map(&String.split(&1, "", trim: true))

    base_cols = Aoc2023.Util.Enum.transpose(base_rows)

    galaxies =
      base_map
      |> Map.filter(fn {_, val} -> val == "#" end)
      |> Map.keys()

    galaxies
    |> Enum.map(fn galaxy ->
      {base_x, base_y} = galaxy

      empty_rows_above =
        base_rows
        |> Enum.take(base_x)
        |> Enum.count(fn row -> Enum.all?(row, &(&1 == ".")) end)

      empty_cols_left =
        base_cols
        |> Enum.take(base_y)
        |> Enum.count(fn row -> Enum.all?(row, &(&1 == ".")) end)

      {base_x + empty_rows_above * (spaces_to_insert - 1),
       base_y + empty_cols_left * (spaces_to_insert - 1)}
    end)
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day11.in", trim: true)

    input
    |> calc_galaxy_positions(2)
    |> distances_to_galaxies()
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day11.in", trim: true)

    input
    |> calc_galaxy_positions(1_000_000)
    |> distances_to_galaxies()
  end
end
