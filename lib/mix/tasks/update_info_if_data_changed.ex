defmodule Mix.Tasks.UpdateInfoIfDataChanged do
  @moduledoc """
  Mix task to conditionally update dictionary info only if data files have changed.

  This task is designed to be run as a pre-commit hook. It:
  - Checks if any files in lib/dictionaries/data/ are being committed
  - Only runs the update_info task if data files have changed
  - Automatically stages the updated dictionaries_info.json file

  ## Usage

      mix update_info_if_data_changed

  """

  use Mix.Task

  @shortdoc "Updates dictionary info only if data files changed"

  @data_path "lib/dictionaries/data"
  @info_file "dictionaries_info.json"

  def run(_args) do
    if data_files_changed?() do
      IO.puts("📁 Data files changed, updating dictionary info...")

      # Run the main update task
      Mix.Task.run("update_info")

      # Stage the updated info file
      stage_info_file()

      IO.puts("✅ Dictionary info updated and staged for commit")
    else
      IO.puts("📄 No data file changes detected, skipping info update")
    end
  end

  defp data_files_changed? do
    # Get list of staged files
    {staged_files, 0} = System.cmd("git", ["diff", "--cached", "--name-only"])

    staged_files
    |> String.split("\n", trim: true)
    |> Enum.any?(&String.starts_with?(&1, @data_path))
  end

  defp stage_info_file do
    case System.cmd("git", ["add", @info_file]) do
      {_, 0} ->
        IO.puts("📄 Staged #{@info_file} for commit")

      {error, _} ->
        IO.puts("⚠️  Warning: Could not stage #{@info_file}: #{error}")
    end
  end
end
