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

  def handle_cast({:suite_finished, _run_us, _load_us}, state) do
    project_key = System.get_env("TESTMETRICS_PROJECT_KEY")
    Results.persist(state, project_key)
    {:noreply, state}
  end

  def handle_cast({:test_started, test}, state) do
    {:noreply, state}
  end

  def handle_cast({:test_finished, test}, state) do
    {:noreply, state}
  end

  def handle_cast({:module_started, test_module}, state) do
    {:noreply, state}
  end

  def handle_cast({:module_finished, test_module}, state) do
    #IO.inspect(test_module)
    {:noreply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end
end
