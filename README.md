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

In a nutshell, you can begin generating randon names with UniqueNamesGenerator by simply specifying a list of one or more dictionaries via [generate/2](`UniqueNamesGenerator.generate/2`). Available dictionary types are `t:UniqueNamesGenerator.Impl.Dictionaries.dictionaries/0`.

```elixir
UniqueNamesGenerator.generate([:adjectives, :animals])
# => Generates ex: "dramatic_limpet"

UniqueNamesGenerator.generate([:adjectives, :colors, :animals])
# => Generates ex: "tremendous_brown_cat"

UniqueNamesGenerator.generate([:adjectives, :names, :numbers])
# => Generates ex: "doubtful_wanda_979"
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

## License
This project is licensed under the MIT License - see the [LICENSE file](https://github.com/jongirard/unique_names_generator/blob/development/LICENSE) for details.

