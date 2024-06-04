defmodule Turms.MixProject do
  use Mix.Project

  def project do
    [
      app: :turms,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Turms",
      description: "End-to-end encrypted online chat service.",
      source_url: "https://github.com/Gravitalia/turms",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: [:dev, :test], runtime: false},
      {:phoenix, "~> 1.7"},
      {:telemetry, "~> 1.0"},
      {:xandra, "~> 0.14"}
    ]
  end

  defp docs do
    [
      main: "Turms",
      logo: "assets/favicon.png",
    ]
  end
end
