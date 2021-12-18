
defmodule Aoc2021_01 do
  def read_values do
    # Returns a list of integers, read from the text file
    File.read!("aoc2021-01.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> Integer.parse(x) end)
    |> Enum.map(fn {x, _} -> x end)  # Drop the remainder, or extra string (e.g \r)
  end

  def part1 do
    read_values()
    |> count_increases
  end

  def count_increases(values) do
    values
    # We want to build tuples values, prev, delta
    # We’ll first initialize the tuples, then computes the delta, to finally replace the delta by directions (inc/dec)
    # value -> {value, :na, :na} to init the variations
    |> Enum.map(fn x -> {x, x, :na} end)
    |> Enum.scan(fn
      {current, _, _}, {prev, _, _} when current >= prev -> {current, prev, :increase}
      {current, _, _}, {prev, _, _} when current < prev -> {current, prev, :decrease}
      {current, _, _}, {prev, _, _} -> {current, prev, :na}
    end)

    # We are only interested in increases, so filter that
    |> Enum.filter(fn {_, _, variation} -> variation == :increase end)
    # Then count them
    |> Enum.count()
    |> IO.inspect()
  end


  def part2 do
    read_values()
    |> count_slide_window_3_increases
  end

  def count_slide_window_3_increases(values) do
    values
    # Create sliding window of 3
    |> Enum.chunk_every(3, 1, :discard)
    # Sum these sliding windows to get a list of sum-of-3 values
    |> Enum.map(&Enum.sum/1)
    # Prepare the cur/pre/variation maps
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn
        [prev, cur] when prev < cur -> {prev, cur, :increase}
        [prev, cur] when prev > cur -> {prev, cur, :decrease}
        [prev, cur]  -> {prev, cur, :na}
       end)

    # We are only interested in increases, so filter that
    |> Enum.filter(fn {_, _, variation} -> variation == :increase end)
    # Then count them
    |> Enum.count()
    |> IO.inspect()
  end


end

Aoc2021_01.part2()
