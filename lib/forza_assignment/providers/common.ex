defmodule ForzaAssignment.Providers.Common do
  def provider_id_by_title(title) do
    %ForzaAssignment.Provider{id: provider_id} = ForzaAssignment.Repo.get_by(ForzaAssignment.Provider, title: title)
    provider_id
  end

  def find_or_create_team(title) do
    case ForzaAssignment.Repo.transaction(fn repo ->
      case repo.get_by(ForzaAssignment.Team, title: title) do
        nil ->
          %ForzaAssignment.Team{title: title}
          |> ForzaAssignment.Team.changeset()
          |> repo.insert
        team -> {:ok, team}
      end
    end) do
      {:ok, result} -> result
      {:error, _} -> find_or_create_team(title)
    end
  end

  def kickoff_at(match) do
    {:ok, kickoff_at, 0} = DateTime.from_iso8601(match["kickoff_at"])
    kickoff_at
  end

  def created_at(match) do
    {:ok, created_at} = DateTime.from_unix(match["created_at"])
    created_at
  end

  def persist(match_object) do
    ForzaAssignment.Match.changeset(match_object, %{})
    |> ForzaAssignment.Repo.insert
  end
end
