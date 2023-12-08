defmodule Aoc2023.Util.Number do
  @doc """
  Returns true if the given character is a number.

    examples:
      iex> Aoc2023.Util.Number.is_number?("1")
      true
      iex> Aoc2023.Util.Number.is_number?("a")
      false
  """
  def is_number?(char) do
    case Integer.parse(char) do
      {_, _} -> true
      _ -> false
    end
  end

  @doc """
  Parses the given written digit to an integer.
  Fails if the given string is not a written digit.

    examples:
      iex> Aoc2023.Util.Number.parse_written_digit("one")
      1
      iex> Aoc2023.Util.Number.parse_written_digit("two")
      2
      iex> Aoc2023.Util.Number.parse_written_digit("seven")
      7
      iex> Aoc2023.Util.Number.parse_written_digit("nine")
      9
  """
  def parse_written_digit(written) do
    case written do
      "one" -> 1
      "two" -> 2
      "three" -> 3
      "four" -> 4
      "five" -> 5
      "six" -> 6
      "seven" -> 7
      "eight" -> 8
      "nine" -> 9
    end
  end

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))
end
