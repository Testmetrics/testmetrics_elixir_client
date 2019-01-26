defmodule TestmetricsElixirClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :testmetrics_elixir_client,
      version: "1.1.2",
      build_per_environment: false,
      elixir: "~> 1.6",
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs],
        check_plt: true
      ],
      deps: deps(),
      name: "testmetrics_elixir_client",
      description: "The official Testmetrics client for ExUnit",
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:benchee, "~> 0.13", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev, :test], runtime: false},
      {:ex_guard, "~> 1.3", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:tesla, ">= 1.1.0"},
      {:jason, ">= 1.0.0"}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE.md),
      licenses: ["MIT"],
      links: %{"Testmetrics" => "https://testmetrics.app"}
    ]
  end
end
