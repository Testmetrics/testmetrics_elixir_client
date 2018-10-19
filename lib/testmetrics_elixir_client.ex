defmodule TestmetricsElixirClient do
  @moduledoc """
  ExUnit formatter implementation that collects data for analysis on Testmetrics.
  """
  use GenServer

  alias TestmetricsElixirClient.Results

  ## Callbacks

  def init(opts) do
    {_, test_store} = Enum.find(opts, {nil, nil}, fn {k, _} -> k == :testmetrics_test_store end)
    {:ok, %{test_store: test_store}}
  end

  def handle_cast({:suite_started, _opts}, state) do
    {:noreply, state}
  end

  def handle_cast({:suite_finished, run_nanoseconds, load_nanoseconds}, state) do
    project_key = System.get_env("TESTMETRICS_PROJECT_KEY")
    total_info = %{run_nanoseconds: run_nanoseconds, load_nanoseconds: load_nanoseconds}
    state = Map.merge(state, total_info)
    Results.persist(state, project_key)
    {:noreply, state}
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
end
