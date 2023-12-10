defmodule Aoc2023.Day10 do
  defp parse_input(input) do
    input
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
    end)
  end

  defp find_start(tile_map) do
    row =
      Enum.find_index(tile_map, fn row ->
        Enum.find(row, fn tile ->
          tile == "S"
        end)
      end)

    col =
      Enum.find_index(Enum.at(tile_map, row), fn tile ->
        tile == "S"
      end)

    {row, col}
  end

  defp find_next_tile_from_start(tile_map, start_pos) do
    {row, col} = start_pos

    neighbours = [
      {row, col - 1},
      {row - 1, col},
      {row + 1, col},
      {row, col + 1}
    ]

    Enum.map(neighbours, fn {row, col} ->
      %{{row, col} => Map.get(tile_map, {row, col}, "X")}
    end)
    |> Enum.reduce(%{}, fn map, acc -> Map.merge(map, acc) end)
    |> Map.filter(fn {_, v} -> v != "X" and v != "." end)
    |> Map.filter(fn {{r, c}, v} ->
      (v == "L" and (r > row or c < col)) or
        (v == "7" and (r < row or c > col)) or
        (v == "J" and (r > row or c > col)) or
        (v == "F" and (r < row or c < col)) or
        (v == "|" and c == col) or
        (v == "-" and r == row)
    end)
    |> Map.keys()
    |> Enum.at(0)
  end

  defp get_direction(current_pos, prev_pos, tile) do
    diff = {elem(current_pos, 0) - elem(prev_pos, 0), elem(current_pos, 1) - elem(prev_pos, 1)}

    dir =
      case diff do
        # from above
        {0, 1} -> "L"
        # from below
        {0, -1} -> "R"
        # from right
        {1, 0} -> "U"
        # from left
        {-1, 0} -> "D"
      end

    exit_dir =
      case tile do
        "|" ->
          case dir do
            "U" -> "D"
            "D" -> "U"
          end

        "-" ->
          case dir do
            "R" -> "L"
            "L" -> "R"
          end

        "L" ->
          case dir do
            "R" -> "U"
            "U" -> "R"
          end

        "J" ->
          case dir do
            "L" -> "U"
            "U" -> "L"
          end

        "7" ->
          case dir do
            "L" -> "D"
            "D" -> "L"
          end

        "F" ->
          case dir do
            "R" -> "D"
            "D" -> "R"
          end
      end

    case exit_dir do
      "U" -> {elem(current_pos, 0) - 1, elem(current_pos, 1)}
      "D" -> {elem(current_pos, 0) + 1, elem(current_pos, 1)}
      "L" -> {elem(current_pos, 0), elem(current_pos, 1) - 1}
      "R" -> {elem(current_pos, 0), elem(current_pos, 1) + 1}
    end
  end

  defp get_path(current_pos, prev_pos, tile_map, start_pos, path) do
    tile = Map.get(tile_map, current_pos)
    IO.inspect(tile)
    IO.inspect(current_pos)

    case tile do
      "S" ->
        [current_pos | path]

      _ ->
        next = get_direction(current_pos, prev_pos, tile)
        get_path(next, current_pos, tile_map, start_pos, [current_pos | path])
    end
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day10.in", trim: true)

    tile_list =
      input
      |> parse_input()

    tile_map =
      tile_list
      |> Enum.with_index()
      |> Enum.map(fn {row, row_index} ->
        Enum.with_index(row)
        |> Enum.map(fn {tile, col_index} ->
          {tile, {row_index, col_index}}
        end)
      end)
      |> List.flatten()
      |> Enum.map(fn {tile, {row, col}} ->
        {{row, col}, tile}
      end)
      |> Map.new()

    start_pos = find_start(tile_list)
    next_pos = find_next_tile_from_start(tile_map, start_pos)

    get_path(next_pos, start_pos, tile_map, start_pos, [])
    |> length()
    |> then(&(&1 / 2))
    |> ceil()
  end

  def shoelace([_]), do: 0
  def shoelace([{y1, x1}, {y2, x2} | t]), do: (y1 + y2) * (x2 - x1) + shoelace([{y2, x2} | t])

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day10.in", trim: true)

    tile_list =
      input
      |> parse_input()

    tile_map =
      tile_list
      |> Enum.with_index()
      |> Enum.map(fn {row, row_index} ->
        Enum.with_index(row)
        |> Enum.map(fn {tile, col_index} ->
          {tile, {row_index, col_index}}
        end)
      end)
      |> List.flatten()
      |> Enum.map(fn {tile, {row, col}} ->
        {{row, col}, tile}
      end)
      |> Map.new()

    start_pos = find_start(tile_list)
    next_pos = find_next_tile_from_start(tile_map, start_pos)

    path = get_path(next_pos, start_pos, tile_map, start_pos, [])
    area = shoelace(path)
    border = length(path)
    (area - border) / 2 + 1
  end
end
