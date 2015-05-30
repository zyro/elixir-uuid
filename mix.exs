defmodule UUID.Mixfile do
  use Mix.Project

  def project do
    [app: :uuid,
     name: "UUID",
     version: "1.0.1",
     source_url: "https://github.com/zyro/elixir-uuid",
     homepage_url: "http://hexdocs.pm/uuid",
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
    [{:ex_doc, "~> 0.7", only: :dev},
     {:earmark, "~> 0.1", only: :dev}]
  end

  # Description.
  defp description do
    """
    UUID generator and utilities for Elixir.
    """
  end

  # Package info.
  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     contributors: ["Andrei Mihu"],
     licenses: ["Apache 2.0"],
     links: %{
       github: "https://github.com/zyro/elixir-uuid",
       docs: "http://hexdocs.pm/uuid"
     }]
  end

end
