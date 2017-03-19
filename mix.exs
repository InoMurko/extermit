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
    [applications: []]
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
     files: ["lib", "mix.exs", "README*"],
     maintainers: ["Ino Murko"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/InoMurko/extermit"}]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
