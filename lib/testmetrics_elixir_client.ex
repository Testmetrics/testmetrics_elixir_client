defmodule TestmetricsElixirClient do
  @moduledoc """
  ExUnit formatter implementation that collects data for analysis on Testmetrics.
  """
  use GenServer

  alias TestmetricsElixirClient.Results

  def init(opts) do
    {_, test_store} = Enum.find(opts, {nil, nil}, fn {k, _} -> k == :testmetrics_test_store end)
    {:ok, %{test_store: test_store}}
  end

  def handle_cast({:suite_started, _opts}, state) do
    {:noreply, state}
  end

  def handle_cast({:suite_finished, run_nanoseconds, _load_nanoseconds}, state) do
    state = Map.merge(state, %{total_run_time: run_nanoseconds, branch: git_branch()})
    Results.persist(state, System.get_env("TESTMETRICS_PROJECT_KEY"))
    {:stop, :normal, state}
  end

  def handle_cast({:test_started, _test}, state) do
    {:noreply, state}
  end

  def handle_cast({:test_finished, _test}, state) do
    {:noreply, state}
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

  @env_vars ["TRAVIS_BRANCH", "CIRCLE_BRANCH", "CI_COMMIT_REF_NAME", "BRANCH_NAME"]
  defp git_branch do
    Enum.find(@env_vars, &System.get_env(&1))
  end
end
