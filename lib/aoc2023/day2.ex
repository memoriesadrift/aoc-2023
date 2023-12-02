defmodule Aoc2023.Day2 do
  defp parse_line(line) do
    line
    |> String.split(":")
    |> Kernel.then(fn [_, x] -> x end)
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn pairs ->
      pairs
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn pair ->
        pair
        |> String.split(" ")
        |> Kernel.then(fn [v, k] -> {k, String.to_integer(v)} end)
      end)
    end)
  end

  defp is_game_possible?(game, red, green, blue) do
    game
    |> Enum.all?(fn pull ->
      pull
      |> Enum.all?(fn {k, v} ->
        case k do
          "red" -> v <= red
          "blue" -> v <= blue
          "green" -> v <= green
        end
      end)
    end)
  end

  defp min_cubes(game) do
    game
    |> Enum.flat_map(fn pull -> pull end)
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.update(acc, k, v, fn x -> max(x, v) end)
    end)
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day2.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Enum.map(&is_game_possible?(&1, 12, 13, 14))
    |> Enum.with_index(1)
    |> Enum.filter(fn {x, _} -> x end)
    |> Enum.map(fn {_, i} -> i end)
    |> Enum.sum()
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day2.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Enum.map(&min_cubes/1)
    |> Enum.map(fn x -> x["red"] * x["green"] * x["blue"] end)
    |> Enum.sum()
  end
end
