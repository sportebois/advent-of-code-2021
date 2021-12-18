
defmodule Aoc2021_02 do
  def read_values do
    # Returns a list of tuples {command, val} read from the text file
    File.read!("aoc2021-02.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.map(fn [command, raw_val] -> {String.to_atom(command), Integer.parse(raw_val)} end)
    |> Enum.map(fn {command, {val, _}} -> {command, val} end)  # Drop the remainder, or extra string (e.g \r)
  end

  def part1 do
    {h, d} = read_values()
    |> compute_part1_horizontal_depth_position
    h * d
    |> IO.inspect
  end

  def compute_part1_horizontal_depth_position (commands) do
    commands
    # Accumulate a {horizontal_pos, depth} tuple
    |> Enum.reduce({0, 0}, fn
      {:forward, val}, {h, d} -> {h + val, d}
      {:up     , val}, {h, d} -> {h      , d-val}
      {:down   , val}, {h, d} -> {h      , d+val}
    end)
  end

  def part2 do
    {h, _, d} = read_values()
    |> compute_part2_aim_horizontal_depth_position
    h * d
    |> IO.inspect
  end

  def compute_part2_aim_horizontal_depth_position (commands) do
    commands
    # Accumulate a {horizontal_pos, aim, depth} tuple
    |> Enum.reduce({0, 0, 0}, fn
      {:up     , val}, {h, a, d} -> {h      , a-val, d}
      {:down   , val}, {h, a, d} -> {h      , a+val, d}
      {:forward, val}, {h, a, d} -> {h + val, a    , d + a*val}
    end)
  end

end

Aoc2021_02.part2()
