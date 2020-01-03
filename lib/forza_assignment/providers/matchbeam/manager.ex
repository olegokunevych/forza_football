defmodule ForzaAssignment.Providers.Matchbeam.Manager do
  alias ForzaAssignment.Providers.Common, as: Common
  @url "http://forzaassignment.forzafootball.com:8080/feed/matchbeam"
  @provider_title "Matchbeam"

  def call do
    provider_id = Common.provider_id_by_title(@provider_title)
    ForzaAssignment.Utils.Fetch.call(@url)
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> match |> prepare_match_object(provider_id) |> Common.persist end)
    |> Enum.to_list
  end

  defp prepare_match_object(match, provider_id) do
    [home_team_title, away_team_title] = teams(match)
    {:ok, home_team} = Common.find_or_create_team(home_team_title)
    {:ok, away_team} = Common.find_or_create_team(away_team_title)
    kickoff_at = Common.kickoff_at(match)
    created_at = Common.created_at(match)

    %ForzaAssignment.Match{
      provider_id: provider_id,
      home_team_id: home_team.id,
      away_team_id: away_team.id,
      kickoff_at: kickoff_at,
      created_at: created_at
    }
  end

  defp teams(match) do
    String.split(match["teams"], " - ")
  end
end
