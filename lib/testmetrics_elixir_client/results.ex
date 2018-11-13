defmodule TestmetricsElixirClient.Results do
  @moduledoc false

  use Tesla
  adapter(Tesla.Adapter.Httpc)
  plug(Tesla.Middleware.BaseUrl, "https://www.testmetrics.app")
  plug(Tesla.Middleware.JSON)

  @doc false
  @spec persist(map, nil | String.t()) :: :ok
  def persist(%{test_store: test_store} = results, project_key) when is_pid(test_store) do
    results = Map.put(results, :key, project_key)
    Agent.update(test_store, fn _ -> Map.delete(results, :test_store) end)
  end

  def persist(results, project_key) do
    _return =
      if project_key do
        post("/results", Map.put(results, :key, project_key))
      end

    :ok
  end
end
