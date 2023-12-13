defmodule Aoc2023.Day13 do
  defp parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn row -> Enum.map(row, &String.split(&1, "", trim: true)) end)
  end

  defp with_transposed(grid), do: {grid, Aoc2023.Util.Enum.transpose(grid)}

  defp reflection(grid, filter_fn) do
    grid
    |> Enum.map(fn row ->
      # skip checking edges, as grids always "reflect" on the edge
      1..(length(row) - 1)
      |> Enum.map(fn point ->
        prev = row |> Enum.take(point)
        next = row |> Enum.drop(point)

        Enum.zip(Enum.reverse(prev), next)
        |> Enum.all?(fn {a, b} -> a == b end)
        |> then(&{point, &1})
      end)
    end)
    |> Aoc2023.Util.Enum.transpose()
    |> Enum.filter(&(filter_fn.(&1) == true))
    |> then(fn res ->
      case res do
        [[{idx, _} | _]] -> idx
        _ -> 0
      end
    end)
  end

  defp part1_reflection_fn(row), do: Enum.all?(row, fn {_, v} -> v == true end)

  defp part2_reflection_fn(row) do
    row
    |> Enum.filter(fn {_, v} -> v == false end)
    |> length() == 1
  end

  defp find_reflection_point({rows, cols}, part) do
    Enum.map([rows, cols], fn grid ->
      case part do
        1 ->
          reflection(grid, &part1_reflection_fn/1)

        2 ->
          reflection(grid, &part2_reflection_fn/1)
      end
    end)
    |> then(fn [row, col] -> {row, col} end)
  end

  defp parts_common() do
    File.read!("input/day13.in")
    |> parse_input()
    |> Enum.map(&with_transposed/1)
  end

  def part1 do
    parts_common()
    |> Enum.map(&find_reflection_point(&1, 1))
    |> Enum.reduce(0, fn {cols, rows}, acc -> acc + (rows * 100 + cols) end)
  end

  def part2 do
    parts_common()
    |> Enum.map(&find_reflection_point(&1, 2))
    |> Enum.reduce(0, fn {cols, rows}, acc -> acc + (rows * 100 + cols) end)
  end
end
