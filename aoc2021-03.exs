
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
    threshold = row_cnt / 2.0
    most_common_bits = sums
    |> Enum.map(fn
        x when x >= threshold -> 1
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
    {gamma, _remainder} = most_common_bits
      |> Enum.join("")
      |> Integer.parse(2)
    gamma
  end

  defp inverse_bits(bits) do
    bits |> Enum.map(fn x ->
      case x  do
        1 -> 0
        _ -> 1
      end
    end)
  end

  defp compute_epsilon(most_common_bits) do
    # epsilon is encoded withthe less common bits,
    # so we need to flip the bits
    less_common_bits = most_common_bits |> inverse_bits()
    {epsilon, _remainder} = less_common_bits |> Enum.join("") |> Integer.parse(2)
    epsilon
  end

  defp compute_power_consumption(gamma, epsilon) do
    gamma * epsilon
  end

  def part2 do
    values = read_values()

    oxygen_generator_rating = compute_oxygen_generator_rating(values)
    IO.inspect("Oxygen #{oxygen_generator_rating}")

    co2_scrubber_rating = compute_co2_scrubber_rating(values)
    IO.inspect("C02 scrubber #{co2_scrubber_rating}")

    life_support_rating = compute_life_support_rating(oxygen_generator_rating, co2_scrubber_rating)
    IO.inspect("Life support rating #{life_support_rating}")
  end

  defp compute_life_support_rating(oxygen_gen_rating, co2_scrubber_rating) do
    oxygen_gen_rating * co2_scrubber_rating
  end

  defp compute_oxygen_generator_rating(values) do
    {val, _remainder} = reduce_by_most_bits(values, 0)
     |> Enum.at(0)
     |> Enum.join("")
     |> Integer.parse(2)
    val
  end

  defp compute_co2_scrubber_rating(values) do
    {val, _remainder} = reduce_by_fewer_bits(values, 0)
     |> Enum.at(0)
     |> Enum.join("")
     |> Integer.parse(2)
    val
  end

  defp reduce_by_most_bits(bit_rows, bit_ind) do
    qualifier = fn bits -> compute_most_common_bits(bits) end
    reduce_by_bits_qualifier(bit_rows, bit_ind, qualifier, &reduce_by_most_bits/2)
  end

  defp reduce_by_fewer_bits(bit_rows, bit_ind) do
    qualifier = fn bits ->
      compute_most_common_bits(bits) |> inverse_bits()
    end
    reduce_by_bits_qualifier(bit_rows, bit_ind, qualifier, &reduce_by_fewer_bits/2)
  end

  defp reduce_by_bits_qualifier(bit_rows, bit_ind, qualifier, rec_fn) do
    commons_bits = qualifier.(bit_rows)
    most_common_significant_bit = commons_bits |> Enum.at(bit_ind)
    filtered_bit_rows = bit_rows |> Enum.filter(fn l -> Enum.at(l, bit_ind) == most_common_significant_bit end)

    # We continue until we reach the last digit
    # or there’s only one result left
    rows_left = filtered_bit_rows |> Enum.count
    width = bit_rows |> List.first |> Enum.count
    next_bit = bit_ind + 1
    case {rows_left, next_bit} do
      {1, _}      -> filtered_bit_rows
      {_, ^width} -> filtered_bit_rows
      _           -> rec_fn.(filtered_bit_rows, next_bit)
    end
  end

end

Aoc2021_03.part2()
