defmodule TestmetricsElixirClient.Results do
  @moduledoc false

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://testmetrics-app.herokuapp.com")
  plug(Tesla.Middleware.JSON)

  @doc false
  @spec persist(map, nil | String.t()) :: :ok
  def persist(results = %{test_store: test_store}, _) when is_pid(test_store) do
    Agent.update(test_store, fn _ -> Map.delete(results, :test_store) end)
  end

  def persist(results, project_key) do
    IO.inspect(project_key, label: :project_key)
    _return =
      if project_key do
        post("/results", Map.put(results, :project_key, project_key))
      end

    :ok
  end
end
