defmodule ForzaAssignment.Providers.FastBall.Manager do
  alias ForzaAssignment.Providers.Common, as: Common
  @url "http://forzaassignment.forzafootball.com:8080/feed/fastball"
  @provider_title "FastBall"

  def call do
    provider_id = Common.provider_id_by_title(@provider_title)
    ForzaAssignment.Utils.Fetch.call(@url)
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> match |> prepare_match_object(provider_id) |> Common.persist end)
    |> Enum.to_list
  end

  defp prepare_match_object(match, provider_id) do
    {:ok, home_team} = Common.find_or_create_team(match["home_team"])
    {:ok, away_team} = Common.find_or_create_team(match["away_team"])
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
end
