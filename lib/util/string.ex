defmodule Aoc2023.Util.String do
  @doc """
  Returns all the contained substrings of the given string.
  Finds substrings with String.contains?/2

    examples:
      iex> Aoc2023.Util.String.contained_substrings("abc", ["a", "b", "c"])
      ["a", "b", "c"]
      iex> Aoc2023.Util.String.contained_substrings("abc", ["ab", "bc"])
      ["ab", "bc"]
      iex> Aoc2023.Util.String.contained_substrings("abc", ["d"])
      []
  """
  def contained_substrings(string, substrings) do
    substrings
    |> Enum.filter(&String.contains?(string, &1))
  end
end
