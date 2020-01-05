defmodule ForzaAssignment.Providers.Matchbeam.ManagerTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Providers.Matchbeam.Manager

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "it runs http request with HTTP 200 response", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, payload())
    end)

    Manager.call("http://localhost:#{bypass.port}/")
  end

  test "it runs http request with unexpected outage", %{bypass: bypass} do
    Bypass.down(bypass)

    Manager.call("http://localhost:#{bypass.port}/")
  end

  defp payload do
    ~s(
    {
      "matches": [
        {
          "created_at": 1578250024,
          "kickoff_at": "2020-01-17T18:00:00Z",
          "teams": "1 FC Saarbrucken - Huddersfield Town"
        },
        {
            "created_at": 1578250029,
            "kickoff_at": "2020-01-22T18:00:00Z",
            "teams": "Granada CF - Karlsruher SC"
        },
        {
            "created_at": 1578250034,
            "kickoff_at": "2020-01-23T18:00:00Z",
            "teams": "UD Almeria - Energie Cottbus"
        }
      ]
    }
    )
  end
end

