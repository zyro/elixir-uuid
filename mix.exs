defmodule UUID.Mixfile do
  use Mix.Project

  @source_url "https://github.com/zyro/elixir-uuid"
  @version "1.2.1"

  def project do
    [
      app: :elixir_uuid,
      name: "UUID",
      version: @version,
      elixir: "~> 1.7",
      docs: docs(),
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:earmark, "~> 1.2", only: :dev, runtime: false},
      {:benchfella, "~> 0.3", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    UUID generator and utilities for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Andrei Mihu"],
      licenses: ["Apache-2.0"],
      links: %{
        "Changelog" => "https://hexdocs.pm/elixir_uuid/changelog.html",
        "GitHub" => @source_url}
    ]
  end
end
