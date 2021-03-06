# TestmetricsElixirClient [![Build Status](https://travis-ci.org/Testmetrics/testmetrics_elixir_client.svg?branch=master)](https://travis-ci.org/Testmetrics/testmetrics_elixir_client) [![Hex](https://img.shields.io/hexpm/v/testmetrics_elixir_client.svg)](https://hex.pm/packages/testmetrics_elixir_client)

The official ExUnit client for Testmetrics. This client collects data about your
ExUnit runs on CI and sends that data to Testmetrics so you can gain valuable
insights about your test suite.

## Installation

This package can be installed by adding `testmetrics_elixir_client` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:testmetrics_elixir_client, "~> 1.1.0", only: [:test]}
  ]
end
```

Once you've done that, just add `TestmetricsElixirClient` to your `ExUnit`
configuration by adding the following line to your `test_helper.exs` file:

```elixir
ExUnit.configure(formatters: [ExUnit.CLIFormatter, TestmetricsElixirClient])
```

That will add `TestmetricsElixirClient` as well as the standard `CLIFormatter`.

Here's [an example commit](https://github.com/devonestes/credo/commit/6c24e2c4fda8d08b02957ea6923e3963e7e34642) showing everything that needs to be done to add
Testmetrics to `credo` - it's just two lines!

In order for the metrics to be send to Testmetrics, you must have your
Testmetrics Project Key set in the "TESTMETRICS_PROJECT_KEY" environment
variable in your CI environment. If this environment variable isn't set, the
collected metrics for your CI run will be discarded. This key should be kept
private and not exposed to the public.

And that's it! Once those steps are done, you'll start collecting data and
seeing how you can improve your test suite!

### Important note!

It is best to run your tests with the `--preload-modules` flag (added in Elixir
1.6.0), since that will preload all modules in all applications. This will make
the measurements **much** more accurate.

## License

`TestmetricsElixirClient` is offered under the MIT license. For the full license
text see [LICENSE.md](https://github.com/testmetrics/testmetrics_elixir_client/blob/master/LICENSE.md).
