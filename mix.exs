defmodule UniqueNamesGenerator.MixProject do
  use Mix.Project

  @source_url "https://github.com/jongirard/unique_names_generator"
  @version "0.2.0"

  def project do
    [
      app: :unique_names_generator,
      description: "Elixir library for generating random and unique names",
      version: @version,
      authors: ["Jon Girard (jongirard)"],
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :ex_doc, "~> 0.31", only: :dev, runtime: false },
      { :dialyxir, "~> 1.3", only: :dev, runtime: false },
    ]
  end

  # ExDoc config
  defp docs() do
    [
      main: "readme", # The main page (entry point) in the docs
      name: "UniqueNamesGenerator",
      canonical: "https://hexdocs.pm/unique_names_generator",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end

  # Hex.pm package config
  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jongirard/unique_names_generator"},
      maintainers: ["Jon Girard"]
    ]
  end
end
