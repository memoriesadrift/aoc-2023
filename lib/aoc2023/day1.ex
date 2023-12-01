defmodule Aoc2023.Day1 do
  defp join_and_sum(list) do
    list
    |> Enum.map(&"#{Enum.at(&1, 0)}#{Enum.at(&1, -1)}")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day1.in", trim: true)

    input
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn chars ->
      chars
      |> Enum.filter(&Aoc2023.Util.Number.is_number?/1)
    end)
    |> join_and_sum()
  end

  def contained_substrings(string, substrings) do
    substrings
    |> Enum.filter(&String.contains?(string, &1))
  end

  defp find_substrings_in_order(string, substrings) do
    string
    |> String.graphemes()
    |> Enum.reduce({[], ""}, fn c, acc ->
      {found, current} = acc
      new = current <> c

      if Aoc2023.Util.Number.is_number?(c) do
        {[String.to_integer(c) | found], ""}
      else
        if String.contains?(new, substrings) do
          [n] = contained_substrings(new, substrings)
          {[Aoc2023.Util.Number.parse_written_digit(n) | found], c}
        else
          {found, new}
        end
      end
    end)
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day1.in", trim: true)

    digits = [
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine"
    ]

    input
    |> Enum.map(fn line ->
      find_substrings_in_order(line, digits)
      |> elem(0)
      |> Enum.reverse()
    end)
    |> join_and_sum()
  end
end
