defmodule Aoc2023.Day7 do
  defp sort_cards([], []), do: true

  defp sort_cards([a | as], [b | bs]) do
    case a == b do
      true -> sort_cards(as, bs)
      false -> a < b
    end
  end

  defp sort_by_cards(cards_a, cards_b) do
    values = "123456789TJQKA" |> String.split("", trim: true)
    values = values |> Enum.with_index() |> Map.new()
    cards_a = String.split(cards_a, "", trim: true) |> Enum.map(&Map.get(values, &1))
    cards_b = String.split(cards_b, "", trim: true) |> Enum.map(&Map.get(values, &1))

    sort_cards(cards_a, cards_b)
  end

  defp hand_type(card_string) do
    card_string
    |> String.split("", trim: true)
    |> Enum.sort()
    |> Kernel.then(fn cards ->
      value =
        case cards do
          [x, x, x, x, x] -> 7
          [_, x, x, x, x] -> 6
          [x, x, x, x, _] -> 6
          [x, x, y, y, y] -> 5
          [x, x, x, y, y] -> 5
          [x, x, x, _, _] -> 4
          [_, x, x, x, _] -> 4
          [_, _, x, x, x] -> 4
          [x, x, y, y, _] -> 3
          [_, x, x, y, y] -> 3
          [x, x, _, y, y] -> 3
          [x, x, _, _, _] -> 2
          [_, x, x, _, _] -> 2
          [_, _, x, x, _] -> 2
          [_, _, _, x, x] -> 2
          [_, _, _, _, _] -> 1
        end

      {card_string, value}
    end)
  end

  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Kernel.then(fn [cards, points] ->
      cards
      |> hand_type()
      |> then(&{&1, String.to_integer(points)})
    end)
  end

  defp get_winnings(lines, jokers?) do
    lines
    |> Enum.sort(fn {{cards_a, points_a}, _}, {{cards_b, points_b}, _} ->
      case points_a == points_b do
        true ->
          case jokers? do
            true ->
              sort_by_cards_jokers(cards_a, cards_b)

            false ->
              sort_by_cards(cards_a, cards_b)
          end

        false ->
          points_a < points_b
      end
    end)
    |> Enum.map(fn {{cards, _}, points} ->
      {cards, points}
    end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, points}, idx} ->
      points * idx
    end)
    |> Enum.sum()
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day7.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> get_winnings(false)
  end

  defp sort_by_cards_jokers(cards_a, cards_b) do
    values = "J123456789TQKA" |> String.split("", trim: true)
    values = values |> Enum.with_index() |> Map.new()
    cards_a = String.split(cards_a, "", trim: true) |> Enum.map(&Map.get(values, &1))
    cards_b = String.split(cards_b, "", trim: true) |> Enum.map(&Map.get(values, &1))

    sort_cards(cards_a, cards_b)
  end

  def hand_type_joker(card_string) do
    cards = card_string |> String.split("", trim: true) |> Enum.sort()
    joker_count = Enum.count(cards, &(&1 == "J"))
    remaining_cards = Enum.filter(cards, &(&1 != "J"))

    value =
      case joker_count do
        # all jokers
        5 ->
          7

        # 4 jokers == 5 of a kind
        4 ->
          7

        # 3 jokers
        3 ->
          case remaining_cards do
            # 5 of a kind
            [x, x] -> 7
            # 4 of a kind
            _ -> 6
          end

        # 2 jokers
        2 ->
          case remaining_cards do
            # 5 of a kind
            [x, x, x] -> 7
            # 4 of a kind
            [x, x, _] -> 6
            [_, x, x] -> 6
            # 3 of a kind
            _ -> 4
          end

        # 1 joker
        1 ->
          case remaining_cards do
            # 5 of a kind
            [x, x, x, x] -> 7
            # 4 of a kind
            [x, x, x, _] -> 6
            [_, x, x, x] -> 6
            # Full house
            [x, x, y, y] -> 5
            # 3 of a kind
            [x, x, _y, _z] -> 4
            [_y, x, x, _z] -> 4
            [_y, _z, x, x] -> 4
            # two of a kind
            _ -> 2
          end
      end

    {card_string, value}
  end

  defp parse_line_jokers(line) do
    line
    |> String.split(" ", trim: true)
    |> Kernel.then(fn [cards, points] ->
      case String.contains?(cards, "J") do
        true ->
          hand_type_joker(cards)

        false ->
          hand_type(cards)
      end
      |> then(&{&1, String.to_integer(points)})
    end)
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day7.in", trim: true)

    input
    |> Enum.map(&parse_line_jokers/1)
    |> get_winnings(true)
  end
end
