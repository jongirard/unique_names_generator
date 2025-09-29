defmodule Mix.Tasks.UpdateInfo do
  @moduledoc """
  Mix task to automatically update counts from dictionaries/data into an info file.

  This task calculates:
  - Total word count for each dictionary
  - Total permutations possible with different dictionary combinations
  - Updates an info file with these statistics

  ## Usage

      mix update_info

  """

  use Mix.Task

  alias UniqueNamesGenerator.Dictionaries.Loader

  @shortdoc "Updates dictionary counts and permutations info"

  @info_file_path "dictionaries_info.json"

  def run(_args) do
    IO.puts("📊 Updating dictionary statistics...")

    # Get all available dictionaries
    dictionaries = Loader.available_dictionaries()

    # Calculate statistics for each dictionary
    dictionary_stats =
      dictionaries
      |> Enum.map(&calculate_dictionary_stats/1)
      |> Enum.into(%{})

    # Calculate permutation combinations
    permutation_stats = calculate_permutation_stats(dictionary_stats)

    # Create complete info structure
    info = %{
      generated_at: DateTime.utc_now() |> DateTime.to_iso8601(),
      total_dictionaries: length(dictionaries),
      dictionaries: dictionary_stats,
      permutations: permutation_stats
    }

    # Write to info file
    write_info_file(info)

    # Display summary
    display_summary(info)

    IO.puts("✅ Dictionary info updated successfully!")
  end

  defp calculate_dictionary_stats(dictionary_name) do
    terms = Loader.load_terms(dictionary_name)
    word_count = length(terms)

    {dictionary_name,
     %{
       word_count: word_count,
       sample_words: Enum.take(terms, 5)
     }}
  end

  defp calculate_permutation_stats(dictionary_stats) do
    # Common combinations for unique name generation
    combinations = [
      %{
        name: "adjective_animal",
        description: "Adjective + Animal (e.g., 'clever_fox')",
        dictionaries: [:adjectives, :animals]
      },
      %{
        name: "adjective_color_animal",
        description: "Adjective + Color + Animal (e.g., 'clever_red_fox')",
        dictionaries: [:adjectives, :colors, :animals]
      },
      %{
        name: "adjective_name",
        description: "Adjective + Name (e.g., 'clever_john')",
        dictionaries: [:adjectives, :names]
      },
      %{
        name: "color_animal",
        description: "Color + Animal (e.g., 'red_fox')",
        dictionaries: [:colors, :animals]
      },
      %{
        name: "adjective_technology",
        description: "Adjective + Technology (e.g., 'clever_algorithm')",
        dictionaries: [:adjectives, :technology]
      },
      %{
        name: "all_dictionaries",
        description: "All available dictionaries combined",
        dictionaries: Map.keys(dictionary_stats)
      }
    ]

    combinations
    |> Enum.map(&calculate_combination_permutations(&1, dictionary_stats))
    |> Enum.into(%{})
  end

  defp calculate_combination_permutations(
         %{dictionaries: dict_names} = combination,
         dictionary_stats
       ) do
    # Check if all required dictionaries exist
    available_dicts =
      dict_names
      |> Enum.filter(&Map.has_key?(dictionary_stats, &1))

    if length(available_dicts) == length(dict_names) do
      # Calculate total permutations (multiply word counts)
      total_permutations =
        available_dicts
        |> Enum.map(&get_in(dictionary_stats, [&1, :word_count]))
        |> Enum.reduce(1, &*/2)

      {combination.name,
       %{
         description: combination.description,
         dictionaries: available_dicts,
         total_permutations: format_number(total_permutations),
         formatted_permutations: format_number(total_permutations)
       }}
    else
      missing = dict_names -- available_dicts

      {combination.name,
       %{
         description: combination.description,
         dictionaries: dict_names,
         total_permutations: 0,
         formatted_permutations: "0 (missing: #{Enum.join(missing, ", ")})"
       }}
    end
  end

  defp format_number(num) when num >= 1_000_000_000_000_000_000 do
    # For extremely large numbers, use simplified notation
    "999T+"
  end

  defp format_number(num) when num >= 1_000_000_000_000_000 do
    rounded = Float.round(num / 1_000_000_000_000_000, 1)
    "#{format_float(rounded)}Q"
  end

  defp format_number(num) when num >= 1_000_000_000_000 do
    rounded = Float.round(num / 1_000_000_000_000, 1)
    "#{format_float(rounded)}T"
  end

  defp format_number(num) when num >= 1_000_000_000 do
    rounded = Float.round(num / 1_000_000_000, 1)
    "#{format_float(rounded)}B"
  end

  defp format_number(num) when num >= 1_000_000 do
    rounded = Float.round(num / 1_000_000, 1)
    "#{format_float(rounded)}M"
  end

  defp format_number(num) when num >= 1_000 do
    rounded = Float.round(num / 1_000, 1)
    "#{format_float(rounded)}K"
  end

  defp format_number(num), do: to_string(num)

  # Helper to format floats nicely (removes .0 if whole number)
  defp format_float(float) do
    rounded = Float.round(float, 0)

    if float == rounded do
      trunc(rounded) |> to_string()
    else
      to_string(float)
    end
  end

  defp write_info_file(info) do
    json_content = Jason.encode!(info, pretty: true)
    File.write!(@info_file_path, json_content)
  end

  defp display_summary(info) do
    IO.puts("\n📈 Dictionary Statistics Summary:")
    IO.puts("================================")
    IO.puts("Total dictionaries: #{info.total_dictionaries}")
    IO.puts("Generated at: #{info.generated_at}")

    IO.puts("\n📚 Dictionary Word Counts:")

    info.dictionaries
    |> Enum.sort_by(fn {_name, stats} -> stats.word_count end, :desc)
    |> Enum.each(fn {name, stats} ->
      IO.puts("  #{name}: #{stats.word_count} words")
    end)

    IO.puts("\n🔢 Permutation Combinations:")

    info.permutations
    |> Enum.each(fn {name, stats} ->
      IO.puts("  #{name}: #{stats.formatted_permutations}")
      IO.puts("    #{stats.description}")
    end)

    IO.puts("\n📄 Info saved to: #{@info_file_path}")
  end
end
