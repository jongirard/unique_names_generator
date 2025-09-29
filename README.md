![Elixir CI](https://github.com/jongirard/unique_names_generator/actions/workflows/elixir.yml/badge.svg)

# UniqueNamesGenerator

Unique Names Generator is an Elixir package for generating random and unique names. Generation utilizes PRNG (pseudo random number generation) for either fully random or seeded name generation. It comes with a list of various dictionaries out of the box, but you can also provide custom ones. Inspired by the great "Unique Names Generator" available on [NPM](https://www.npmjs.com/package/unique-names-generator) by Andrea Sonny.

API Documentation built with [ExDoc](https://github.com/elixir-lang/ex_doc) can be found at <https://hexdocs.pm/unique_names_generator>.

## Installation

The package can be installed from [Hex](https://hex.pm/docs/publish)
by adding `unique_names_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:unique_names_generator, "~> 0.2.0"}
  ]
end
```
Then run `mix deps.get`.

## Usage

In a nutshell, you can begin generating randon names with UniqueNamesGenerator by simply specifying a list of one or more dictionaries via [generate/2](`UniqueNamesGenerator.generate/2`). The system automatically discovers all available dictionaries from text files.

You can see all available dictionaries at any time:

```elixir
UniqueNamesGenerator.available_dictionaries()
# => [:adjectives, :animals, :architecture, :colors, :countries, :food, :languages, :names, :numbers, :scientists, :star_wars, :technology]
```

Built-in dictionaries include:
- `:adjectives` - Descriptive adjectives
- `:animals` - Animal names
- `:architecture` - Architecture and building terms
- `:colors` - Color names
- `:countries` - Country names
- `:food` - Food and culinary terms
- `:languages` - Programming and spoken languages
- `:names` - Person names
- `:numbers` - Numbers 1-999
- `:scientists` - Famous scientist names
- `:star_wars` - Star Wars character names
- `:technology` - Technology and computing terms

```elixir
UniqueNamesGenerator.generate([:adjectives, :animals])
# => Generates ex: "dramatic_limpet"

UniqueNamesGenerator.generate([:adjectives, :colors, :animals])
# => Generates ex: "tremendous_brown_cat"

UniqueNamesGenerator.generate([:adjectives, :names, :numbers])
# => Generates ex: "doubtful_wanda_979"

UniqueNamesGenerator.generate([:scientists, :architecture])
# => Generates ex: "einstein_cathedral"

UniqueNamesGenerator.generate([:countries, :food])
# => Generates ex: "france_croissant"
```

To use custom dictionaries, simply include your list of strings as part of the dictionaries list:

```elixir
drinks = ["Sprite", "Coca-Cola", "Juice", "Tea"]
UniqueNamesGenerator.generate([:colors, drinks])
# => Generates ex: "cyan_sprite"
```

### Config options

UniqueNamesGenerator can be used with either the default provided config (`%{seperator: "_", style: :lowercase }`) or by specifying any of your own configuration options for seeding, seperator and style. See the options type, `t:UniqueNamesGenerator.Impl.Dictionaries.options/0`, for more details on possible options.

```elixir
UniqueNamesGenerator.generate([:colors, :animals], %{ style: :capital, separator: " " })
# => Generates ex: "Lavender Marlin"
```

### Seeded Generation

A seed can be used to deterministically generate a name. As long as the provided seed is the same, then the generated name will also always be the same. Simply provide a string or integer in the [options config map](`t:UniqueNamesGenerator.Impl.Dictionaries.options/0`) of the seed key, ie; `%{ seed: "hello" }`. 

_(**Usecase example:** generate a username for an authenticated user based on UUID. Ex: `03bf0706-b7e9-33b8-aee5-c6142a816478` will always generate the name "brown_dooku_247" when used together with the colors/star_wars/numbers dictionaries)._

```elixir
UniqueNamesGenerator.generate([:colors, :star_wars, :numbers], %{ seed: "03bf0706-b7e9-33b8-aee5-c6142a816478" })
# => Seed "03bf0706-b7e9-33b8-aee5-c6142a816478" always generates: "brown_dooku_247"
```

## Adding New Dictionaries

UniqueNamesGenerator makes it extremely easy to add new dictionaries. Simply create a new text file in the `lib/dictionaries/data/` directory with one term per line:

**Example: Creating a fruits dictionary**

1. Create `lib/dictionaries/data/fruits.txt`:
```
apple
banana
orange
grape
strawberry
mango
kiwi
```

2. The dictionary becomes immediately available:
```elixir
UniqueNamesGenerator.available_dictionaries()
# => [:adjectives, :animals, ..., :fruits, ...]

UniqueNamesGenerator.generate([:colors, :fruits])
# => Generates ex: "purple_mango"
```

**Requirements:**
- File must be in `lib/dictionaries/data/` directory
- File must have `.txt` extension
- One term per line (newline-separated)
- File name becomes the dictionary atom (e.g., `fruits.txt` → `:fruits`)

## Data Sources

Dictionary data sourced from:
- Original dictionaries: Custom curated lists
- Extended dictionaries: [aziele/unique-namer](https://github.com/aziele/unique-namer) repository

## License
This project is licensed under the MIT License - see the [LICENSE file](https://github.com/jongirard/unique_names_generator/blob/development/LICENSE) for details.

