defmodule UUID.Mixfile do
  use Mix.Project

  def project do
    [app: :uuid,
     version: "0.1.0",
     elixir: "== 0.13.3 or ~> 0.14.0-dev",
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

end
