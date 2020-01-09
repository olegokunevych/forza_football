defmodule ForzaAssignment.Matches.Matches do
  def build_match(provider_id, match, home_team_id, away_team_id) do
    kickoff_at = kickoff_at(match)
    created_at = created_at(match)

    %ForzaAssignment.Matches.Match{
      provider_id: provider_id,
      home_team_id: home_team_id,
      away_team_id: away_team_id,
      kickoff_at: kickoff_at,
      created_at: created_at
    }
  end
  def persist(match_object) do
    ForzaAssignment.Matches.Match.changeset(match_object, %{})
    |> ForzaAssignment.Repo.insert
  end

  def kickoff_at(nil), do: nil
  def kickoff_at(%{"kickoff_at" => nil}), do: nil
  def kickoff_at(%{"kickoff_at" => datetime}) do
    {:ok, kickoff_at, 0} = DateTime.from_iso8601(datetime)
    kickoff_at
  end

  def created_at(nil), do: nil
  def created_at(%{"created_at" => nil}), do: nil
  def created_at(%{"created_at" => datetime}) do
    {:ok, created_at} = DateTime.from_unix(datetime)
    created_at
  end
end
