defmodule UniqueNamesGenerator do
  alias UniqueNamesGenerator.Impl.Dictionaries
  @moduledoc """
  Documentation for `UniqueNamesGenerator`.
  """

  @doc """
  Dictionaries list is required (at least one of `t:UniqueNamesGenerator.Impl.Dictionaries.dictionaries/0` and/or a custom list of strings). Config map optional.

  ## Examples

      iex> UniqueNamesGenerator.generate([:colors, :animals], %{seed: "hello", style: :capital, separator: " "})
      "Lavender Marlin"

      iex> UniqueNamesGenerator.generate([:colors, :star_wars], %{seed: "03bf0706-b7e9-33b8-aee5-c6142a816478", style: :capital, separator: " "})
      "Brown Dooku"

      iex> drinks = ["Sprite", "Coca-Cola", "Juice", "Tea"]
      iex(1)> UniqueNamesGenerator.generate([:colors, drinks, :numbers], %{seed: 50, style: :capital, separator: "-"})
      "Teal-Tea-902"

      iex> UniqueNamesGenerator.generate([:adjectives, :animals])
      "respectable_bear"

  """
  @spec generate(nonempty_list(Dictionaries.dictionaries() | [String.t, ...])) :: String.t
  @spec generate(nonempty_list(Dictionaries.dictionaries() | [String.t, ...]), Dictionaries.options()) :: String.t
  defdelegate generate(dictionaries, options \\ %{}), to: Dictionaries
end
