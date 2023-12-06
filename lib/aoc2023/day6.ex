defmodule Aoc2023.Day6 do
  defp parse_line(line) do
    line
    |> String.split(": ", trim: true)
    |> Enum.at(1)
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day6.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Kernel.then(fn [times, dists] ->
      times
      |> Enum.map(fn t -> {0..t, t} end)
      |> Enum.zip(dists)
    end)
    |> find_winning_options()
  end

  defp find_winning_options(list) do
    list
    |> Enum.map(fn {{range, time}, dist} ->
      range
      |> Enum.to_list()
      |> Enum.map(fn t ->
        t * (time - t)
      end)
      |> Enum.filter(&(&1 > dist))
      |> Enum.count()
    end)
    |> Enum.product()
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day6.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Kernel.then(fn [times, dists] ->
      time = Enum.join(times, "") |> String.to_integer()

      [
        {
          {0..time, time},
          Enum.join(dists, "") |> String.to_integer()
        }
      ]
    end)
    |> find_winning_options()
  end
end
