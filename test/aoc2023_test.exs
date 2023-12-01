defmodule Aoc2023Test do
  use ExUnit.Case
  doctest Aoc2023

  test "day 1 part 1" do
    assert Aoc2023.Day1.part1() == 55090
  end

  test "day 1 part 2" do
    assert Aoc2023.Day1.part2() == 54845
  end
end
