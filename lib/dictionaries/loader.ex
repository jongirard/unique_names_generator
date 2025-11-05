defmodule UniqueNamesGenerator.Dictionaries.Loader do
  @moduledoc """
  Loads dictionary terms from text files at compile time for memory efficiency.
  """

  @data_path Path.join([__DIR__, "data"])

  # Load all dictionaries at compile time into module attributes
  @dictionaries (
                  data_path = Path.join([__DIR__, "data"])

                  for file <- File.ls!(data_path),
                      String.ends_with?(file, ".txt") do
                    # Mark each file as an external resource for recompilation
                    @external_resource Path.join(data_path, file)

                    dict_name = String.replace(file, ".txt", "") |> String.to_atom()

                    terms =
                      Path.join(data_path, file)
                      |> File.read!()
                      |> String.trim()
                      |> String.split("\n")
                      |> Enum.map(&String.trim/1)
                      |> Enum.reject(&(&1 == ""))

                    {dict_name, terms}
                  end
                  |> Map.new()
                )

  @doc """
  Get the path to the data directory
  """
  def data_path, do: @data_path

  @doc """
  List all available dictionary names based on compiled dictionaries
  """
  def available_dictionaries do
    Map.keys(@dictionaries)
  end

  @doc """
  Load terms from compiled dictionary cache
  """
  def load_terms(dictionary_name) when is_atom(dictionary_name) do
    case Map.get(@dictionaries, dictionary_name) do
      nil ->
        raise ArgumentError, message: "Dictionary file #{dictionary_name}.txt not found"

      terms ->
        terms
    end
  end

  @doc """
  Check if a dictionary exists in compiled cache
  """
  def dictionary_exists?(dictionary_name) when is_atom(dictionary_name) do
    Map.has_key?(@dictionaries, dictionary_name)
  end
end
