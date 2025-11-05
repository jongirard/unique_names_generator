# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UniqueNamesGenerator is an Elixir library for generating random and unique names using PRNG (pseudo-random number generation). It supports both fully random and seeded name generation using configurable dictionaries.

**Key Architecture Pattern**: Dictionary data is loaded at compile time into module attributes using `@external_resource` markers, enabling automatic recompilation when dictionary files change. This provides memory efficiency and fast runtime access.

## Essential Commands

### Development Workflow
```bash
# Get dependencies
mix deps.get

# Run tests
mix test

# Run single test file
mix test test/path/to/test_file.exs

# Run specific test line
mix test test/path/to/test_file.exs:42

# Code formatting (auto-runs on pre-push)
mix format

# Linting with Credo (auto-runs on pre-push)
mix credo --strict

# Type checking with Dialyzer
mix dialyzer

# Generate documentation
mix docs

# Update dictionary statistics
mix update_info
```

### Git Hooks
The project uses `git_hooks` configured in `config/config.exs`:
- **pre-commit**: Runs `mix update_info_if_data_changed` to update dictionary statistics if data files changed
- **pre-push**: Runs `mix credo --strict` and `mix format` to enforce code quality

## Architecture

### Core Module Structure

**Entry Point**: `UniqueNamesGenerator` (lib/unique_names_generator.ex)
- Delegates to `UniqueNamesGenerator.Impl.Dictionaries`
- Public API: `generate/2` and `available_dictionaries/0`

**Dictionary Loading**: `UniqueNamesGenerator.Dictionaries.Loader` (lib/dictionaries/loader.ex)
- Loads all `.txt` files from `lib/dictionaries/data/` at compile time
- Uses `@external_resource` to mark dictionary files for recompilation tracking
- Dictionary terms stored in module attribute `@dictionaries` as a map
- File name becomes dictionary atom (e.g., `fruits.txt` → `:fruits`)

**Generation Logic**: `UniqueNamesGenerator.Impl.Dictionaries` (lib/impl/dictionaries.ex)
- Handles word selection, formatting, and concatenation
- Supports custom dictionaries (lists of strings) alongside built-in dictionaries
- Style options: `:capital`, `:titlecase`, `:uppercase`, `:lowercase`
- Configurable separator (default: `"_"`)

**Seeding**: `UniqueNamesGenerator.Impl.Seed` (lib/impl/seed.ex)
- Deterministic generation using `:rand.seed(:exro928ss, {a, b, c})`
- Converts string/integer seeds to consistent random state

### Dictionary System Design

Dictionary discovery is fully automatic. To add new dictionaries:

1. Create `lib/dictionaries/data/dictionary_name.txt`
2. Add one term per line (newline-separated)
3. Recompile - the dictionary becomes immediately available

The `@external_resource` markers ensure that changes to dictionary files trigger automatic recompilation, keeping the compiled dictionary map in sync with file contents.

### Mix Tasks

**mix update_info**: Generates `dictionaries_info.json` with statistics
- Word counts per dictionary
- Permutation calculations for common combinations
- Used for documentation and project metrics

**mix update_info_if_data_changed**: Conditional version for pre-commit hook
- Only updates info file if dictionary data files changed
- Prevents unnecessary updates on non-dictionary commits

## Testing Strategy

Tests organized by module:
- `test/unique_names_generator_test.exs` - Public API tests
- `test/impl/dictionaries_test.exs` - Internal generation logic
- `test/impl/seed_test.exs` - Seeding behavior

DocTests are embedded in module documentation and run automatically with `mix test`.

## Code Quality Standards

- **Credo**: Enforces Elixir style guide and code consistency
- **Dialyxir**: Static type analysis using Dialyzer
- **ExDoc**: Documentation must include `@moduledoc` and `@doc` annotations
- **Formatting**: Use `mix format` (`.formatter.exs` configuration)

## Important Implementation Details

**Random Number Generation**:
- Unseeded: Uses `:crypto.strong_rand_bytes(12)` for entropy
- Seeded: Deterministic via `:rand.seed(:exro928ss, {a, b, c})`
- Same seed + same dictionaries = identical output

**Compile-Time vs Runtime**:
- Dictionary loading happens at compile time (build artifact includes all terms)
- Runtime generation only involves random selection and formatting
- Adding new dictionaries requires recompilation (automatic via `@external_resource`)

**Dictionary Data Sources**:
- Original dictionaries: Custom curated
- Extended dictionaries: [aziele/unique-namer](https://github.com/aziele/unique-namer)
- Cities: [SimpleMaps World Cities Database](https://simplemaps.com/data/world-cities)
