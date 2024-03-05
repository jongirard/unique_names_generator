defmodule UniqueNamesGenerator.Impl.Dictionaries do
  alias UniqueNamesGenerator.Impl.Seed

  @type t :: list(String.t)
  @type style() :: :capital | :uppercase | :lowercase
  @type options() :: %{ optional(:separator) => String.t, optional(:style) => style(), optional(:seed) => String.t | integer() }
  @config %{separator: "_", style: :lowercase, seed: nil}

  @spec expand_word_list(String.t) :: [String.t]
  def expand_word_list(dictionary) do
    "../../assets/#{dictionary}.txt"
    |> Path.expand(__DIR__)
    |> File.read()
    |> parse_file(dictionary)
  end

  @spec word_list(String.t | [String.t, ...]) :: [String.t]
  def word_list(dictionary) do
    cond do
      is_list(dictionary) ->
        dictionary
      is_binary(dictionary) ->
        expand_word_list(dictionary)
    end
  end

  @spec parse_file({:ok, binary()}, any()) :: [String.t]
  def parse_file({ :ok, file }, _) do
    String.split(file)
  end

  def parse_file({ :error, _reason }, dictionary) do
    raise ArgumentError, message: "The dictionary: #{dictionary} is invalid"
  end

  @spec map_dictionaries([String.t]) :: [[String.t]]
  def map_dictionaries(dictionaries) do
    Enum.map(dictionaries, fn dictionary -> word_list(dictionary) end)
  end

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
  def get_random_float(seed) do
    %{ a: a, b: b, c: c } = call_seeder(seed)
    :rand.seed(:exro928ss, {a, b, c})

    # Uses the seed produced above
    :rand.uniform()
  end

  @spec format_word(String.t, style()) :: String.t
  def format_word(word, style) do
    case style do
      :capital ->
        String.capitalize(word)
      :uppercase ->
        String.upcase(word)
      :lowercase ->
        String.downcase(word)
      _ ->
        word
    end
  end

  @spec set_defaults(options()) :: %{separator: String.t, style: style(), seed: String.t | integer() }
  def set_defaults(options) do
    Enum.into(options, @config)
  end

  @spec generate([String.t], options()) :: String.t
  @spec generate([String.t, ...]) :: String.t
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