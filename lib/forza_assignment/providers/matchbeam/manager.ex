defmodule ForzaAssignment.Providers.Matchbeam.Manager do
  @url "http://forzaassignment.forzafootball.com:8080/feed/matchbeam"

  def call do
    ForzaAssignment.Utils.Fetch.call(@url)
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> match |> prepare_match_object |> persist end)
    |> Enum.to_list
  end

  defp prepare_match_object(match) do
    [home_team, away_team] = teams(match)
    kickoff_at = kickoff_at(match)
    created_at = created_at(match)

    %ForzaAssignment.Match{
      provider: "Matchbeam",
      home_team: home_team,
      away_team: away_team,
      kickoff_at: kickoff_at,
      created_at: created_at
    }
  end

  defp teams(match) do
    String.split(match["teams"], " - ")
  end

  defp kickoff_at(match) do
    {:ok, kickoff_at, 0} = DateTime.from_iso8601(match["kickoff_at"])
    kickoff_at
  end

  defp created_at(match) do
    {:ok, created_at} = DateTime.from_unix(match["created_at"])
    created_at
  end

  defp persist(match_object) do
    ForzaAssignment.Match.changeset(match_object, %{})
    |> ForzaAssignment.Repo.insert
  end
end
