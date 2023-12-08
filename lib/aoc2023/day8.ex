defmodule Aoc2023.Day8 do
  defp parse_input(input) do
    [instructions | directions] = input
    instructions = String.split(instructions, "", trim: true)

    map =
      directions
      |> Enum.map(fn line ->
        [start, values] = String.split(line, " = (")
        [left, right] = String.split(values, ", ")
        right = String.replace(right, ")", "")
        %{start => %{left: left, right: right}}
      end)
      |> Enum.reduce(%{}, fn map, acc -> Map.merge(map, acc) end)

    {instructions, map}
  end

  defp nextPath(place, instruction, map) do
    %{left: left, right: right} = map[place]

    case instruction do
      "L" ->
        left

      "R" ->
        right
    end
  end

  defp follow_instructions(starting_node, instructions, map, end_node?) do
    Stream.cycle(instructions)
    |> Enum.reduce_while({starting_node, 0}, fn instruction, {place, count} ->
      next = nextPath(place, instruction, map)

      if end_node?.(next) do
        {:halt, {next, count + 1}}
      else
        {:cont, {next, count + 1}}
      end
    end)
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day8.in", trim: true)

    input
    |> parse_input()
    |> then(fn {instructions, map} ->
      follow_instructions("AAA", instructions, map, fn n -> n == "ZZZ" end)
    end)
  end

  defp get_all_starting_nodes(map) do
    map
    |> Map.keys()
    |> Enum.filter(fn key -> String.ends_with?(key, "A") end)
  end

  defp follow_instructions_parallel(starting_nodes, instructions, map) do
    Enum.map(starting_nodes, fn node ->
      follow_instructions(node, instructions, map, fn n -> String.ends_with?(n, "Z") end)
    end)
    |> Enum.reduce(1, fn {_, count}, acc -> Aoc2023.Util.Number.lcm(count, acc) end)
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day8.in", trim: true)

    input
    |> parse_input()
    |> then(fn {instructions, map} ->
      starts = get_all_starting_nodes(map)
      follow_instructions_parallel(starts, instructions, map)
    end)
  end
end
