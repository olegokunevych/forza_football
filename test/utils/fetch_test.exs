defmodule ForzaAssignment.Utils.FetchTests do
  use ExUnit.Case

  alias ForzaAssignment.Utils.Fetch

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "request with HTTP 200 response", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, payload())
    end)

    assert {:ok, _ } = Fetch.call("http://localhost:#{bypass.port}/")
  end

  test "request with unexpected outage", %{bypass: bypass} do
    Bypass.down(bypass)

    assert {:error, []} = Fetch.call("http://localhost:#{bypass.port}/")
  end

  test "request with HTTP 503 response", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 503, [])
    end)

    assert {:error, [] } = Fetch.call("http://localhost:#{bypass.port}/")
  end

  test "request with HTTP 400 response", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 400, [])
    end)

    assert {:error, [] } = Fetch.call("http://localhost:#{bypass.port}/")
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
        }
      ]
    }
    )
  end
end
