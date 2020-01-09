defmodule ForzaAssignment.Providers.FastBall.Manager do
  @moduledoc "Fastball Manager module for fetch, perform, persist matches info"
  alias ForzaAssignment.Providers.Providers, as: Providers
  alias ForzaAssignment.Matches.Matches, as: Matches
  alias ForzaAssignment.Teams.Teams, as: Teams
  @url "http://forzaassignment.forzafootball.com:8080/feed/fastball"
  @provider_title "FastBall"

  def call(url \\ @url) do
    provider_id = Providers.provider_id_by_title(@provider_title)
    {_, matches} = ForzaAssignment.Utils.Fetch.call(url, query_params())
    matches
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> match |> prepare_match_object(provider_id) |> Matches.persist end)
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
    write_last_checked_at()
    {:ok, home_team} = Teams.find_or_create_team(match["home_team"])
    {:ok, away_team} = Teams.find_or_create_team(match["away_team"])

    Matches.build_match(provider_id, match, home_team.id, away_team.id)
  end

  defp write_last_checked_at do
    :ets.insert(:last_checked_at, {:fastball, :os.system_time(:second)})
  end
end
