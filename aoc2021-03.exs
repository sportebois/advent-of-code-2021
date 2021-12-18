
defmodule Aoc2021_03 do
  def read_values do
    # Returns a list of lists of 0 and 1 read from the text file
    File.read!("aoc2021-03.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)  # Remove any extra \r
    |> Enum.map(&String.graphemes/1)  # Convert to list of 0 and 1
    |> Enum.map( fn l -> Enum.map(l, &Integer.parse/1) end)
    |> Enum.map( fn l -> Enum.map(l, fn {x, _} -> x end) end)
  end

  def part1 do
    most_common_bits = read_values() |> compute_most_common_bits()
    gamma = compute_gamma(most_common_bits)
    epsilon = compute_epsilon(most_common_bits)

    power_consumption = compute_power_consumption(gamma, epsilon)
    power_consumption
    |> IO.inspect
  end

  defp compute_most_common_bits(bit_rows) do
    width = bit_rows |> List.first |> Enum.count

    # Our accumulator will be the count of 1, plus the count of rows (to not have to re-enumerate the whole list)
    acc = [0] ++ List.duplicate(0, width)

    [row_cnt | sums] = bit_rows |> Enum.reduce(acc, &reduce_bit_row/2)

    # What’s the threshold for most common digit: if it’s sum is more than half of the rows
    threshold = row_cnt / 2
    most_common_bits = sums
    |> Enum.map(fn
        x when x > threshold -> 1
        _ -> 0
      end)
    most_common_bits
  end

  defp reduce_bit_row(bits, acc) do
    # Utility function for compute_most_common_bits
    # We take the current row and the accumulator,
    # and we sum the accumulator indices according to the bits
    [row_cnt | sums] = acc
    row_cnt = row_cnt + 1
    # For each 1 in bits, we need to sum the appropriate sums digit
    sums = List.zip([sums, bits]) |> Enum.map(fn {s, b} -> s+b end)
    [row_cnt | sums]
  end

  defp compute_gamma(most_common_bits) do
    {gamma, _} = most_common_bits
      |> Enum.join("")
      |> Integer.parse(2)
    gamma
  end

  defp compute_epsilon(most_common_bits) do
    # epsilon is encoded withthe less common bits,
    # so we need to flip the bits
    less_common_bits = most_common_bits |> Enum.map(fn x ->
      case x  do
        1 -> 0
        _ -> 1
      end
    end)
    {epsilon, _} = less_common_bits |> Enum.join("") |> Integer.parse(2)
    epsilon
  end

  defp compute_power_consumption(gamma, epsilon) do
    gamma * epsilon
  end



end

Aoc2021_03.part1()
