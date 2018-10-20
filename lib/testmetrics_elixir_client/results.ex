defmodule TestmetricsElixirClient.Results do
  @moduledoc false

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://testmetrics-app.herokuapp.com"
  plug Tesla.Middleware.JSON

  @doc false
  @spec persist(map, nil | String.t()) :: :ok
  def persist(results = %{test_store: test_store}, nil) when is_pid(test_store) do
    Agent.update(test_store, fn _ -> Map.delete(results, :test_store) end)
  end

  def persist(%{run_nanoseconds: run_time}, _project_key) do
    _ = post("/results", %{total_run_time: run_time})
    :ok
  end
end
