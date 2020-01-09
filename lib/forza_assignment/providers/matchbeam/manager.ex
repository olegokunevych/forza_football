defmodule ForzaAssignment.Providers.Matchbeam.Manager do
  @moduledoc "Matchbeam Manager module for fetch, perform, persist matches info"
  alias ForzaAssignment.Providers.Providers, as: Providers
  alias ForzaAssignment.Matches.Matches, as: Matches
  alias ForzaAssignment.Teams.Teams, as: Teams
  @url "http://forzaassignment.forzafootball.com:8080/feed/matchbeam"
  @provider_title "Matchbeam"

  def call(url \\ @url) do
    provider_id = Providers.provider_id_by_title(@provider_title)
    {_, matches} = ForzaAssignment.Utils.Fetch.call(url)
    matches
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> match |> prepare_match_object(provider_id) |> ForzaAssignment.Matches.Matches.persist end)
    |> Enum.to_list
  end

  defp prepare_match_object(match, provider_id) do
    [home_team_title, away_team_title] = teams(match)
    {:ok, home_team} = Teams.find_or_create_team(home_team_title)
    {:ok, away_team} = Teams.find_or_create_team(away_team_title)

    Matches.build_match(provider_id, match, home_team.id, away_team.id)
  end

  defp teams(match) do
    String.split(match["teams"], " - ")
  end
end
