defmodule Impl.DictionariesTest do
  use ExUnit.Case

  alias UniqueNamesGenerator.Impl.Dictionaries
  alias UniqueNamesGenerator.Dictionaries.Colors
  alias UniqueNamesGenerator.Dictionaries.Adjectives

  describe "generate/1" do
    test "it can generate a name with default config and packaged dictionary" do
      assert is_binary(Dictionaries.generate([:star_wars])) === true
    end

    test "it can generate a name with custom dictionary" do
      words = ["Lorem", "Ipsum"]
      assert Dictionaries.generate([words]) === "Lorem" || "Ipsum"
    end

    test "it can generate a name with multiple packaged dictionaries" do
      result = Dictionaries.generate([:colors, :adjectives])

      assert String.contains?(result, Colors.list_all())
      assert String.contains?(result, Adjectives.list_all())
    end
    end
  end

  describe "generate/2" do
    seed_string_cases = %{
      "hello" => "lavender_mace_windu",
      "5976423a-ee35-11e3-8569-14109ff1a304" => "indigo_leia_organa",
      "03bf0706-b7e9-33b8-aee5-c6142a816478" => "brown_dooku"
    }

    seed_integer_cases = %{
      3 => "tan_swift",
      50 => "teal_tiglon",
      5049483 => "maroon_muskox",
    }

    Enum.each seed_string_cases, fn({input, expected_output}) ->
      test "based on a PRNG string based seed of #{input} it can generate a predicted word: #{expected_output}" do
        assert Dictionaries.generate([:colors, :star_wars], %{ seed: unquote(input) }) === unquote(expected_output)
      end
    end

    Enum.each seed_integer_cases, fn({input, expected_output}) ->
      test "based on a PRNG integer based seed of #{input} it can generate a predicted word: #{expected_output}" do
        assert Dictionaries.generate([:colors, :animals], %{ seed: unquote(input) }) === unquote(expected_output)
      end
    end

    test "it can generate a word using a custom separator string" do
      assert Dictionaries.generate([:colors, :animals], %{ seed: "pigeon", separator: " " }) === "beige carp"
    end

    test "it can generate a word using a custom separator string and capitalized word style" do
      assert Dictionaries.generate([:colors, :animals], %{ seed: "pigeon", separator: " ", style: :capital }) === "Beige Carp"
    end

    test "it can generate a word using a custom separator string and uppercased word style" do
      assert Dictionaries.generate([:colors, :animals], %{ seed: "soccer", separator: "-", style: :uppercase }) === "MOCCASIN-ORANGUTAN"
    end
  end
end
