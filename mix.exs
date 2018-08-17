defmodule TestmetricsElixirClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :testmetrics_elixir_client,
      version: "0.1.0",
      build_per_environment: false,
      elixir: "~> 1.6",
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs]
      ],
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:benchee, "~> 0.13.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_guard, "~> 1.3", only: [:dev]},
    ]
  end
end
