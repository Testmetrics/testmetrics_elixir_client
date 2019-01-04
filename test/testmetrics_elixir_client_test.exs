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

    assert %{
             total_run_time: _,
             key: _,
             branch: _,
             sha: _,
             metadata: %{
               elixir_version: _,
               erlang_version: _,
               ci_platform: _
             },
             tests: [
               %{
                 name: name1,
                 total_run_time: _,
                 state: state1
               },
               %{
                 name: name2,
                 total_run_time: _,
                 state: state2
               }
             ]
           } = results

    assert [name1, name2] == [
             "Elixir.TestmetricsElixirClientTest.BasicTest test true",
             "Elixir.TestmetricsElixirClientTest.BasicTest test false"
           ]

    assert [state1, state2] == ["passed", "failed"]
  end

  test "new slow test" do
    Process.sleep(2000)
    assert true
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
