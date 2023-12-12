defmodule Aoc2023.Day12 do
  alias Aoc2023.Util.Memo, as: Memo

  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> then(fn [springs, regions] ->
      springs =
        springs
        |> String.split("", trim: true)

      regions = String.split(regions, ",", trim: true)
      {springs, regions}
    end)
  end

  defp walk_options_rec([], []), do: 1
  defp walk_options_rec([], _regions), do: 0

  defp walk_options_rec(springs, []) do
    case Enum.member?(springs, "#") do
      true ->
        Memo.update({springs, []}, 0)
        0

      _ ->
        Memo.update({springs, []}, 1)
        1
    end
  end

  defp walk_options_rec(springs, regions) do
    [region | rest_regions] = regions
    [spring | rest_springs] = springs

    cache_hit = Memo.get({springs, regions})

    case cache_hit do
      nil ->
        case spring do
          "#" ->
            len = length(springs)

            cond do
              len < region or
                  Enum.member?(Enum.slice(springs, 0..(region - 1)), ".") ->
                Memo.update({springs, regions}, 0)
                0

              len == region ->
                case length(rest_regions) do
                  0 ->
                    Memo.update({springs, regions}, 1)
                    1

                  _ ->
                    Memo.update({springs, regions}, 0)
                    0
                end

              Enum.at(springs, region) == "#" ->
                Memo.update({springs, regions}, 0)
                0

              true ->
                rest = Enum.slice(springs, (region + 1)..-1)

                res = walk_options_rec(rest, rest_regions)
                Memo.update({springs, regions}, res)
                res
            end

          "." ->
            rest_springs = Enum.drop_while(springs, &(&1 == "."))
            walk_options_rec(rest_springs, regions)

          _ ->
            total_one = walk_options_rec(["#" | rest_springs], regions)
            Memo.update({["#" | rest_springs], regions}, total_one)

            total_two = walk_options_rec(rest_springs, regions)
            Memo.update({rest_springs, regions}, total_two)
            total_one + total_two
        end

      val ->
        val
    end
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day12.in", trim: true)

    Memo.start_link()

    res =
      input
      |> Enum.map(&parse_line/1)
      |> Enum.map(fn {springs, regions} -> {springs, Enum.map(regions, &String.to_integer/1)} end)
      |> Enum.map(fn {springs, regions} -> walk_options_rec(springs, regions) end)
      |> Enum.sum()

    Memo.stop()

    res
  end

  defp explode(springs, regions) do
    {[springs, "?", springs, "?", springs, "?", springs, "?", springs]
     |> List.flatten(),
     [regions, regions, regions, regions, regions]
     |> List.flatten()}
  end

  def part2 do
    input =
      Aoc2023.Util.File.read_lines("input/day12.in", trim: true)

    Memo.start_link()

    res =
      input
      |> Enum.map(&parse_line/1)
      |> Enum.map(fn {springs, regions} -> {springs, Enum.map(regions, &String.to_integer/1)} end)
      |> Enum.map(fn {springs, regions} -> explode(springs, regions) end)
      |> Enum.map(fn {springs, regions} -> walk_options_rec(springs, regions) end)
      |> Enum.sum()

    Memo.stop()

    res
  end
end
