defmodule TestmetricsElixirClientTest do
  use ExUnit.Case, async: true
  alias ExUnit.Server

  test "collects all the metrics we need and sends them to be persisted" do
    defmodule BasicTest do
      use ExUnit.Case, async: true

      test "true" do
        assert true
      end

      test "false" do
        assert false
      end
    end

    test_store = run_tests()
    results = Agent.get(test_store, & &1)
    assert %{total_run_time: _, branch: _} = results
  end

  defp run_tests do
    ExUnit.configure(formatters: [TestmetricsElixirClient])
    {:ok, pid} = Agent.start(fn -> %{} end)
    ExUnit.configure(testmetrics_test_store: pid)
    Server.modules_loaded()
    ExUnit.run()
    ExUnit.configure(testmetrics_test_store: nil)
    pid
  end
end
