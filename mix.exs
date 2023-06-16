defmodule UUID.Mixfile do
  use Mix.Project

  @version "1.2.1"

  def project do
    [app: :elixir_uuid,
     name: "UUID",
     version: @version,
     elixir: "~> 1.7",
     docs: [extras: ["README.md", "CHANGELOG.md"],
            main: "readme",
            source_ref: "v#{@version}"],
     source_url: "https://github.com/zyro/elixir-uuid",
     description: description(),
     package: package(),
     deps: deps(),
     dialyzer: [
      plt_add_deps: :apps_direct,
      plt_file: {:no_warn, "priv/plts/project.plt"}
     ]]
  end

  # Application configuration.
  def application do
    []
  end

  # List of dependencies.
  defp deps do
    [{:ex_doc, "~> 0.19", only: :dev},
     {:earmark, "~> 1.2", only: :dev},
     {:benchfella, "~> 0.3", only: :dev},
     {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false}]
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
     maintainers: ["Andrei Mihu"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/zyro/elixir-uuid"}]
  end

end
