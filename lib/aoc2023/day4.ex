defmodule Aoc2023.Day4 do
  defp parse_line(line) do
    line
    |> String.split(": ", trim: true)
    |> Enum.at(1)
    |> String.split("|")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer(&1)) end)
    |> Kernel.then(fn [a, b] -> {a, b} end)
  end

  def part1 do
    input = Aoc2023.Util.File.read_lines("input/day4.in", trim: true)

    input
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {winning, ours} ->
      ours
      |> Enum.filter(&Enum.member?(winning, &1))
      |> Enum.count()
      |> Kernel.then(fn pow ->
        case pow do
          0 ->
            0

          n ->
            :math.pow(2, n - 1)
        end
      end)
    end)
    |> Enum.sum()
  end

  def scratchcards_rec([], _, card_total), do: card_total

  def scratchcards_rec([card | t], card_map, card_total) do
    {{winning, ours}, idx} = card

    matching =
      ours
      |> Enum.filter(&Enum.member?(winning, &1))
      |> Enum.count()

    case matching do
      0 ->
        scratchcards_rec(t, card_map, card_total)

      _ ->
        won_cards =
          (idx + 1)..(idx + matching)
          |> Enum.map(fn i ->
            case Map.fetch(card_map, i) do
              {:ok, fetched_card} ->
                fetched_card

              # What to do with cards that are OOB?
              :error ->
                nil
            end
          end)
          |> Enum.filter(&(&1 != nil))

        scratchcards_rec(won_cards ++ t, card_map, card_total + matching)
    end
  end

  def part2 do
    input = Aoc2023.Util.File.read_lines("input/day4.in", trim: true)

    card_list =
      input
      |> Enum.map(&parse_line/1)
      |> Enum.with_index(1)

    card_count = length(card_list)

    cards = 1..card_count |> Stream.zip(card_list) |> Enum.into(%{})

    scratchcards_rec(card_list, cards, card_count)
  end
end
