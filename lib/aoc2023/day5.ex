defmodule Aoc2023.Day5 do
  defp parse_input(input, are_seeds_range) do
    [seeds | maps] = input

    lookup =
      maps
      |> Enum.chunk_by(fn line ->
        case String.first(line) do
          char ->
            Aoc2023.Util.Number.is_number?(char)
        end
      end)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [[name], ranges] ->
        {name, ranges}
      end)
      |> Enum.map(fn {name, ranges} ->
        range_map =
          Enum.map(ranges, fn line ->
            range = String.split(line, " ") |> Enum.map(&String.to_integer/1)

            case range do
              [dest_start, source_start, length] ->
                %{{source_start, source_start + length - 1} => dest_start}
            end
          end)

        {name, range_map}
      end)
      |> Enum.map(fn {name, range_map} ->
        [str, _] = String.split(name, " ")
        [from, to] = String.split(str, "-to-")
        {from, to, range_map}
        %{from => {to, range_map}}
      end)
      |> Enum.reduce(&Map.merge(&1, &2))

    seeds =
      case are_seeds_range do
        true ->
          seeds
          |> String.split(" ")
          |> Kernel.then(fn [_ | t] -> t end)
          |> Enum.map(&String.to_integer/1)
          |> Enum.chunk_every(2)
          |> Enum.map(fn [start, len] ->
            {start, start + len - 1}
          end)

        false ->
          seeds
          |> String.split(" ")
          |> Kernel.then(fn [_ | t] -> t end)
          |> Enum.map(&String.to_integer/1)
      end

    {seeds, lookup}
  end

  defp lookup({what, num}, lookups, looking_for) do
    with true <- looking_for != what,
         {:ok, {to, range_map}} <- Map.fetch(lookups, what) do
      matching_range =
        Enum.find(range_map, fn map ->
          {start, lim} = Map.keys(map) |> Enum.at(0)
          start <= num and num <= lim
        end)

      case is_nil(matching_range) do
        true ->
          lookup({to, num}, lookups, looking_for)

        false ->
          {start, lim} = Map.keys(matching_range) |> Enum.at(0)

          result =
            Map.get(matching_range, {start, lim}, num)
            |> Kernel.then(fn n -> n + (num - start) end)

          lookup({to, result}, lookups, looking_for)
      end
    else
      false ->
        num

      :error ->
        IO.puts("Error: #{what} #{num}")
        nil
    end
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day5.in", trim: true)

    input
    |> parse_input(false)
    |> Kernel.then(fn {seeds, lookups} ->
      seeds
      |> Enum.map(fn seed ->
        lookup({"seed", seed}, lookups, "location")
      end)
    end)
    |> Enum.min()
  end

  defp get_resulting_ranges(from_range, range_map) do
    {from_start, from_lim} = from_range

    Enum.filter(range_map, fn map ->
      {start, lim} = Map.keys(map) |> Enum.at(0)

      (lim >= from_start and start <= from_lim) or
        (from_lim >= start and from_start <= lim)
    end)
    |> Enum.map(fn map ->
      {start, lim} = Map.keys(map) |> Enum.at(0)

      contained_range = {
        max(start, from_start),
        min(lim, from_lim)
      }

      {contained_range, map}
    end)
    |> Enum.sort()
    |> Kernel.then(fn ranges ->
      case ranges do
        [] ->
          [{from_range, %{{from_start, from_lim} => from_start}}]

        [h | _] ->
          # first bound
          {contained_range, _} = h
          {start, _} = contained_range

          case from_start < start do
            true ->
              [{{from_start, start - 1}, %{{from_start, start - 1} => from_start}} | ranges]

            false ->
              ranges
          end
      end
    end)
    |> Kernel.then(fn ranges ->
      # last bound
      ranges = Enum.reverse(ranges)
      [h | _] = ranges
      {contained_range, _} = h
      {_start, lim} = contained_range

      case from_lim > lim do
        true ->
          [{{lim + 1, from_lim}, %{{lim + 1, from_lim} => lim + 1}} | ranges]

        false ->
          ranges
      end
    end)
    |> Enum.reverse()
    |> Enum.reduce([], fn {contained_range, map}, acc ->
      {start, _lim} = contained_range

      case acc do
        [] ->
          [{contained_range, map}]

        [{{_h_start, h_lim}, _} | _] ->
          case h_lim + 1 != start do
            true ->
              # construct in between range
              [{{h_lim + 1, start - 1}, %{{h_lim + 1, start - 1} => h_lim + 1}} | acc]

            false ->
              [{contained_range, map} | acc]
          end
      end
    end)
    |> Enum.map(fn {contained_range, map} ->
      {start, lim} = contained_range
      {range_start, range_lim} = Map.keys(map) |> Enum.at(0)

      result =
        Map.get(map, {range_start, range_lim}, start)
        |> Kernel.then(fn n -> n + (start - range_start) end)

      {result, result + (lim - start)}
    end)
  end

  defp lookup_ranges({what, ranges}, lookups, looking_for) do
    with true <- looking_for != what,
         {:ok, {to, range_map}} <- Map.fetch(lookups, what) do
      matching_ranges =
        Enum.flat_map(ranges, fn range ->
          get_resulting_ranges(range, range_map)
        end)

      lookup_ranges({to, matching_ranges}, lookups, looking_for)
    else
      false ->
        ranges

      :error ->
        IO.puts("Error: #{what} #{inspect(ranges)}")
        nil
    end
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day5.in", trim: true)

    input
    |> parse_input(true)
    |> Kernel.then(fn {seeds, lookups} ->
      lookup_ranges({"seed", seeds}, lookups, "location")
    end)
    |> Enum.map(fn {start, _} ->
      start
    end)
    |> Enum.min()
  end
end
