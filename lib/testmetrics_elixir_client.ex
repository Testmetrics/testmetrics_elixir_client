defmodule TestmetricsElixirClient do
  @moduledoc """
  ExUnit formatter implementation that collects data for analysis on Testmetrics.
  """
  use GenServer

  alias TestmetricsElixirClient.Results

  def init(opts) do
    {_, test_store} = Enum.find(opts, {nil, nil}, fn {k, _} -> k == :testmetrics_test_store end)
    {:ok, %{test_store: test_store, tests: %{}}}
  end

  def handle_cast({:suite_started, _opts}, state) do
    key = System.get_env("TESTMETRICS_PROJECT_KEY")
    {elixir_version, erlang_version} = elixir_and_erlang_versions()

    state =
      Map.merge(state, %{
        branch: git_branch(),
        sha: git_sha(),
        metadata: %{
          elixir_version: elixir_version,
          erlang_version: erlang_version,
          ci_platform: ci_platform()
        }
      })

    Results.persist(state, key)
    {:noreply, state}
  end

  def handle_cast({:suite_finished, run_nanoseconds, _load_nanoseconds}, state) do
    key = System.get_env("TESTMETRICS_PROJECT_KEY")
    state =
      Map.merge(state, %{
        total_run_time: run_nanoseconds,
        tests: Enum.reduce(state.tests, [], &format_tests/2)
      })

    Results.persist(state, key)
    {:noreply, state}
  end

  def handle_cast({:test_started, _test}, state) do
    {:noreply, state}
  end

  def handle_cast({:test_finished, test}, state) do
    tests =
      state.tests
      |> Map.put_new(test.module, %{})
      |> put_in([test.module, test.name], test)

    {:noreply, %{state | tests: tests}}
  end

  def handle_cast({:module_started, _test_module}, state) do
    {:noreply, state}
  end

  def handle_cast({:module_finished, _test_module}, state) do
    {:noreply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  @branch_vars ["TRAVIS_BRANCH", "CIRCLE_BRANCH", "CI_COMMIT_REF_NAME", "BRANCH_NAME"]
  defp git_branch do
    case Enum.find(@branch_vars, &System.get_env(&1)) do
      nil -> nil
      var -> System.get_env(var)
    end
  end

  @sha_vars ["TRAVIS_COMMIT", "CIRCLE_SHA1", "CI_COMMIT_SHA", "REVISION"]
  defp git_sha do
    case Enum.find(@sha_vars, &System.get_env(&1)) do
      nil -> nil
      var -> System.get_env(var)
    end
  end

  defp ci_platform do
    case Enum.find(@sha_vars, &System.get_env(&1)) do
      "TRAVIS_COMMIT" -> "Travis CI"
      "CIRCLE_SHA1" -> "Circle CI"
      "CI_COMMIT_SHA" -> "Gitlab CI"
      "REVISION" -> "Semaphore CI"
      nil -> "Unknown"
    end
  end

  defp elixir_and_erlang_versions do
    {output, 0} = System.cmd("elixir", ["--version"])
    [_, erlang, elixir] = Regex.run(~r/\A(.*)\n\n(.*)/, output)
    {elixir, erlang}
  end

  defp format_tests({module, tests}, acc) do
    Enum.reduce(tests, acc, fn {_, test}, acc ->
      state =
        case test.state do
          nil -> "passed"
          {:failed, _} -> "failed"
          {:skipped, _} -> "skipped"
          {:excluded, _} -> "excluded"
          {:invalid, _} -> "invalid"
        end

      name = "#{module} #{test.name}"

      [%{name: name, total_run_time: test.time, state: state} | acc]
    end)
  end
end
