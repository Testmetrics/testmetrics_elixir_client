defmodule TestmetricsElixirClient.Results do
  @moduledoc false

  @doc false
  @spec persist(map, nil | String.t()) :: :ok
  def persist(results = %{test_store: test_store}, nil) when is_pid(test_store) do
    Agent.update(test_store, fn _ -> Map.delete(results, :test_store) end)
  end

  def persist(_results, _project_key) do
    :ok
  end
end
