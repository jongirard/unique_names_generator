defmodule UniqueNamesGenerator.Impl.Dictionaries do
  @moduledoc """
    Documentation for `UniqueNamesGenerator.Impl.Dictionaries`.
  """

  alias UniqueNamesGenerator.Impl.Seed
  alias UniqueNamesGenerator.Dictionaries

  @type style() :: :capital | :titlecase | :uppercase | :lowercase
  @type options() :: %{ optional(:separator) => String.t, optional(:style) => style(), optional(:seed) => String.t | integer() }
  @type dictionaries() :: :animals | :adjectives | :colors | :languages | :names | :star_wars
  @config %{separator: "_", style: :lowercase, seed: nil}

  @spec camelize_dictionary(atom()) :: String.t
  defp camelize_dictionary(dictionary) do
    dictionary
    |> Atom.to_string()
    |> Macro.camelize()
  end

  @doc false
  @spec match_word_list(atom()) :: [String.t]
  def match_word_list(dictionary) do
    try do
      module = Module.safe_concat(Dictionaries, camelize_dictionary(dictionary))
      module.list_all()
    rescue
      UndefinedFunctionError -> raise_invalid_dictionary(dictionary)
      ArgumentError -> raise_invalid_dictionary(dictionary)
    end
  end

  defp raise_invalid_dictionary(dictionary) do
    raise ArgumentError, message: "Dictionary, #{dictionary} is invalid"
  end

  @spec word_list(dictionaries() | [String.t, ...]) :: [String.t]
  defp word_list(dictionary) do
    cond do
      is_list(dictionary) ->
        dictionary
      is_atom(dictionary) ->
        match_word_list(dictionary)
      true ->
        raise ArgumentError, message: "Dictionary contains invalid dictionary type"
    end
  end

  @spec map_dictionaries([dictionaries() | String.t | [String.t, ...], ...]) :: [[String.t]]
  defp map_dictionaries(dictionaries) do
    Enum.map(dictionaries, fn dictionary -> word_list(dictionary) end)
  end

  @doc false
  @spec call_seeder(String.t | nil) :: %{a: integer(), b: integer(), c: integer()}
  def call_seeder(seed) do
    cond do
      is_nil(seed) == true ->
        << a :: 32, b :: 32, c :: 32 >> = :crypto.strong_rand_bytes(12)
        %{ a: a, b: b, c: c }
      is_nil(seed) == false ->
        Seed.generate_seed(seed)
    end
  end

  @spec get_random_float(any()) :: float()
  defp get_random_float(seed) do
    %{ a: a, b: b, c: c } = call_seeder(seed)
    :rand.seed(:exro928ss, {a, b, c})

    # Uses the seed produced above
    :rand.uniform()
  end

  @spec format_word(String.t, style()) :: String.t
  defp format_word(word, style) do
    case style do
      :capital ->
        String.capitalize(word)
      :titlecase ->
        :string.titlecase(word)
      :uppercase ->
        String.upcase(word)
      :lowercase ->
        String.downcase(word)
    end
  end

  @spec set_defaults(options()) :: %{separator: String.t, style: style(), seed: String.t | integer() }
  defp set_defaults(options) do
    Enum.into(options, @config)
  end

  @spec generate(nonempty_list(dictionaries() | [String.t, ...])) :: String.t
  @spec generate(nonempty_list(dictionaries() | [String.t, ...]), options()) :: String.t
  def generate(dictionaries, options \\ %{}) do
    %{separator: separator, style: style, seed: seed} = set_defaults(options)

    map_dictionaries(dictionaries)
    |> Enum.reduce(nil, fn x, acc ->

      random_float = get_random_float(seed)
      rnd = floor(random_float * length(x))

      word = Enum.at(x, rnd)
      |> format_word(style)

      cond do
        acc -> "#{acc}#{separator}#{word}"
        true -> "#{word}"
      end
    end)
  end
end
