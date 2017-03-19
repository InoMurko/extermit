defmodule ExTermit.Mixfile do
  use Mix.Project

  def project do
    [app: :extermit,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    ExTermit is an Elixir based, updated Termit.
    https://github.com/dvv/termit
    Library for serializing Erlang terms to signed encrypted binaries and reliably deserializing them back.
    """
  end

  defp package do
    [name: :extermit,
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Ino Murko"],
     licenses: ["Apache 2.0"],
     links: %{}]
  end

  defp deps do
    []
  end
end
