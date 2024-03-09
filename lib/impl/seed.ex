defmodule UniqueNamesGenerator.Impl.Seed do
  @moduledoc false
  import Bitwise

  @doc false
  @spec generate_seed(binary() | integer()) :: %{a: integer(), b: integer(), c: integer()}
  def generate_seed(seed) do
    seed
    |> process_received_value()
    |> mulberry32()
    |> remove_decimal()
    |> chunk_result()
    |> convert_chunk_to_map()
  end

  @spec process_received_value(String.t | integer()) :: integer() | Exception.t
  defp process_received_value(seed) do
    cond do
      is_binary(seed) ->
        transform_string(seed)
      is_integer(seed) ->
        seed
      true ->
        raise ArgumentError, message: "The seed may only be either a string or integer value"
    end
  end

  @spec transform_string(String.t) :: integer()
  defp transform_string(seed) do
    seed <> <<0>>
    |> :binary.bin_to_list()
    |> Enum.join()
    |> String.to_integer()
  end

  @doc false
  @spec remove_decimal(float()) :: [String.t]
  def remove_decimal(float) do
    float
    |> Float.to_string()
    |> String.codepoints
    |> Enum.filter(fn stringified_point -> stringified_point !== "." end)
  end

  @doc false
  @spec chunk_result([String.t]) :: [[String.t], ...]
  def chunk_result(result) do
    desired_amount_of_sublists = 3

    total_length = length(result)
    chunk_length = Integer.floor_div(total_length, desired_amount_of_sublists)

    Enum.chunk_every(result, chunk_length, chunk_length, :discard)
  end

  @doc false
  @spec convert_chunk_to_map([[String.t], ...]) :: %{a: integer(), b: integer(), c: integer()}
  def convert_chunk_to_map(chunk) do
    [a, b, c] = Enum.map(chunk, fn numbers ->
      List.to_string(numbers)
      |> String.to_integer()
    end)

    %{ a: a, b: b, c: c }
  end

  @doc false
  @spec mulberry32(integer()) :: float()
  def mulberry32(seed) do
    t = seed + 0x6d2b79f5 ||| 0

    t = imul(bxor(t,(bsr(t, 15))), t ||| 1)
    t = bxor(t, bsr(t, 7));
    t = bxor(t, t + imul(bxor(t, bsr(t, 7)), t ||| 61))

    (bxor(t, bsr(t, 14))) / 4294967296
  end

  @doc false
  @spec imul(integer(), integer()) :: integer()
  def imul(x, y) do
    <<result::signed-32>> = <<x * y::32>>
    result
  end
end
