defmodule ForzaAssignment.Providers.FastBall.Manager do
  alias ForzaAssignment.Providers.Common, as: Common
  @url "http://forzaassignment.forzafootball.com:8080/feed/fastball"
  @provider_title "FastBall"

  def call(url \\ @url) do
    provider_id = Common.provider_id_by_title(@provider_title)
    {_, matches} = ForzaAssignment.Utils.Fetch.call(url, query_params())
    matches
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> match |> prepare_match_object(provider_id) |> Common.persist end)
    |> Enum.to_list
  end

  defp query_params do
    {_, query_params} = case :ets.lookup(:last_checked_at, :fastball) do
      [{_, res}] -> {:ok, [last_checked_at: res]}
      [] -> {:error, []}
    end
    query_params
  end

  defp prepare_match_object(match, provider_id) do
    {:ok, home_team} = Common.find_or_create_team(match["home_team"])
    {:ok, away_team} = Common.find_or_create_team(match["away_team"])
    kickoff_at = Common.kickoff_at(match)
    created_at = Common.created_at(match)

    write_last_checked_at()

    %ForzaAssignment.Match{
      provider_id: provider_id,
      home_team_id: home_team.id,
      away_team_id: away_team.id,
      kickoff_at: kickoff_at,
      created_at: created_at
    }
  end

  defp write_last_checked_at do
    :ets.insert(:last_checked_at, {:fastball, :os.system_time(:second)})
  end
end
