defmodule Aoc2023.Day9 do
  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_sequence_diffs_rec(sequence, add?) do
    case Enum.all?(sequence, &(&1 == 0)) do
      true ->
        0

      false ->
        [h | rest] = sequence

        new_sequence =
          rest
          |> Enum.reduce({[], h}, fn num, {diffs, last} ->
            {[num - last | diffs], num}
          end)

        {diffs, _} = new_sequence

        case add? do
          true ->
            Enum.at(Enum.reverse(sequence), 0) +
              find_sequence_diffs_rec(Enum.reverse(diffs), true)

          false ->
            Enum.at(sequence, 0) - find_sequence_diffs_rec(Enum.reverse(diffs), false)
        end
    end
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day9.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Enum.map(&find_sequence_diffs_rec(&1, true))
    |> Enum.sum()
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day9.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Enum.map(&find_sequence_diffs_rec(&1, false))
    |> Enum.sum()
  end
end
