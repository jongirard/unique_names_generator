defmodule Impl.SeedTest do
  use ExUnit.Case
  alias UniqueNamesGenerator.Impl.Seed

  describe "generate_seed/1" do
    seed_cases = %{
      "hello" => %{a: 4276, b: 25910, c: 14616},
      "03bf0706-b7e9-33b8-aee5-c6142a816478" => %{a: 3182, b: 52076, c: 62768},
      "5976423a-ee35-11e3-8569-14109ff1a304" => %{a: 27177, b: 863917, c: 313516},
      1041011081081110 => %{a: 4276, b: 25910, c: 14616},
      48519810248554854459855101574551519856459710110153459954495250975649545255560 => %{a: 3182, b: 52076, c: 62768}
    }

    Enum.each seed_cases, fn({ seed, %{ a: a, b: b, c: c }}) ->
      test "Given a seed value of (#{seed}) it can generate a map result of: (a):#{a}, (b):#{b}, (c)#{c}" do
        assert Seed.generate_seed(unquote(seed)) === %{ a: unquote(a), b: unquote(b), c: unquote(c) }
      end
    end
  end

  describe "remove_decimal/1" do
    seed_float_cases = %{
      0.08091996633447707 => ["0", "0", "8", "0", "9", "1", "9", "9", "6", "6", "3", "3", "4", "4", "7", "7", "0", "7"],
      0.4276259101461619 => ["0", "4", "2", "7", "6", "2", "5", "9", "1", "0", "1", "4", "6", "1", "6", "1", "9"]
    }

    Enum.each seed_float_cases, fn({float, expected_output}) ->
      test "Given a float value of (#{float}) it can generate a list result of: #{expected_output}" do
        assert Seed.remove_decimal(unquote(float)) === unquote(expected_output)
      end
    end
  end

  describe "chunk_result/1" do
    seed_list_cases = %{
      ["0", "0", "8", "0", "9", "1", "9", "9", "6", "6", "3", "3", "4", "4", "7", "7", "0", "7"] => [["0", "0", "8", "0", "9", "1"], ["9", "9", "6", "6", "3", "3"], ["4", "4", "7", "7", "0", "7"]],
      ["0", "4", "2", "7", "6", "2", "5", "9", "1", "0", "1", "4", "6", "1", "6", "1", "9"] => [["0", "4", "2", "7", "6"], ["2", "5", "9", "1", "0"], ["1", "4", "6", "1", "6"]],
    }

    Enum.each seed_list_cases, fn({list_input, expected_output}) ->
      test "Given a list value of (#{list_input}) it can generate a chunked list result" do
        assert Seed.chunk_result(unquote(list_input)) === unquote(expected_output)
      end
    end
  end

  describe "convert_chunk_to_map/1" do
    seed_list_cases = %{
      [["0", "0", "8", "0", "9", "1"], ["9", "9", "6", "6", "3", "3"], ["4", "4", "7", "7", "0", "7"]] => %{a: 8091, b: 996633, c: 447707},
      [["0", "4", "2", "7", "6"], ["2", "5", "9", "1", "0"], ["1", "4", "6", "1", "6"]] => %{a: 4276, b: 25910, c: 14616},
    }

    Enum.each seed_list_cases, fn({list_input, %{ a: a, b: b, c: c }}) ->
      [input_a, _, _] = list_input

      test "Given a chunked list value of ([0]#{input_a}, ..., ...) it can generate a mapped result" do
        assert Seed.convert_chunk_to_map(unquote(list_input)) === %{ a: unquote(a), b: unquote(b), c: unquote(c) }
      end
    end
  end

  describe "imul/2" do
    seed_integer_cases = %{
      [2, 4] => 8,
      [-1, 8] => -8,
      [-2, -2] => 4,
      [-5, 12] => -60
    }

    Enum.each seed_integer_cases, fn({[a, b], expected_output}) ->
      test "Given (#{a}, #{b}) it can generate a result of: #{expected_output}" do
        assert Seed.imul(unquote(a), unquote(b)) === unquote(expected_output)
      end
    end
  end

  describe "mulberry32/1" do
    seed_integer_cases = %{
      2 => 0.08091996633447707,
      1041011081081110 => 0.4276259101461619,
      48519810248554854459855101574551519856459710110153459954495250975649545255560 => 0.3182520766276866,
    }

    Enum.each seed_integer_cases, fn({seed, expected_output}) ->
      test "Given a seed value of (#{seed}) it can generate a float result of: #{expected_output}" do
        assert Seed.mulberry32(unquote(seed)) === unquote(expected_output)
      end
    end
  end
end
