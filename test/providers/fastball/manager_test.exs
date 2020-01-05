defmodule ForzaAssignment.Providers.FastBall.ManagerTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Providers.FastBall.Manager

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
            "away_team": "Southampton FC",
            "created_at": 1578138777,
            "home_team": "Albacete Balompie",
            "kickoff_at": "2020-01-26T11:00:00Z"
        },
        {
            "away_team": "Juventus Turin",
            "created_at": 1578138782,
            "home_team": "Dynamo Dresden",
            "kickoff_at": "2020-01-24T11:00:00Z"
        },
        {
            "away_team": "Racing Santander",
            "created_at": 1578138787,
            "home_team": "Sevilla FC",
            "kickoff_at": "2020-01-23T11:00:00Z"
        }
      ]
    }
    )
  end
end
