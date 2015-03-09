defmodule UUID.Mixfile do
  use Mix.Project

  def project do
    [app: :uuid,
     version: "1.0.0",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  # Application configuration.
  def application do
    []
  end

  # List of dependencies.
  defp deps do
    []
  end

  # Description.
  defp description do
    """
    UUID generator and utilities for Elixir.
    """
  end

  # Package info.
  defp package do
    [ files: ["lib", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Andrei Mihu"],
      licenses: ["Apache 2.0"],
      links: %{ "GitHub" => "https://github.com/zyro/elixir-uuid" } ]
  end

end
