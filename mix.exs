defmodule UniqueNamesGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :unique_names_generator,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
end
