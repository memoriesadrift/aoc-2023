defmodule Aoc2023.Util.File do
  @doc """
  Returns the path to the input file for the given day.
  
    examples:
      iex> File.day_to_path(1)
      "input/day1.in"
  """
  def day_to_path(day) when is_integer(day), do: "input/day#{day}.in"

  @doc """
  Reads the lines of the given file.
  Accepted options:
    * trim: boolean, default: false
      Passed to `String.split/3`
  
    examples:
      iex> File.read_lines("input/example.in", [trim: false])
      ["1000", "2000", "3000", "", "4000", "", "5000", "6000", "", "7000", "8000", "9000", "", "10000", ""]
  """
  def read_lines(path, opts \\ []) do
    default_opts = [trim: false]
    opts = Keyword.merge(default_opts, opts)
    with {:ok, data} <- File.read(path) do
      data
      |> String.split("\n", opts)
    end
  end
  
end
