defmodule UniqueNamesGenerator.Dictionaries.Numbers do
  @moduledoc false
  @terms 1..999

  @spec list_all() :: [integer(), ...]
  def list_all() do
    Enum.to_list(@terms)
    |> Enum.map(fn term ->
        Integer.to_string(term)
      end)
    end
end
