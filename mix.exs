defmodule UUID.Mixfile do
  use Mix.Project

  @version "1.2.1"

  def project do
    [
      app: :elixir_uuid,
      name: "UUID",
      version: @version,
      elixir: "~> 1.7",
      docs: [extras: ["README.md", "CHANGELOG.md"], main: "readme", source_ref: "v#{@version}"],
      source_url: "https://github.com/avenueplace/elixir-uuid",
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Application configuration.
  def application do
    []
  end

  # List of dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22.0", only: :dev, runtime: false},
      {:earmark, "~> 1.2", only: :dev},
      {:benchfella, "~> 0.3", only: :dev}
    ]
  end

  # Description.
  defp description do
    """
    UUID generator and utilities for Elixir.
    """
  end

  # Package info.
  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Avenue.place"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/avenueplace/elixir-uuid"}
    ]
  end
end
