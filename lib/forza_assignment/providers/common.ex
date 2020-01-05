defmodule ForzaAssignment.Providers.Common do
  def provider_id_by_title(title) do
    provider = ForzaAssignment.Repo.get_by(ForzaAssignment.Provider, title: title)
    case provider do
      nil -> nil
      _ -> provider.id
    end
  end

  # function implemented to solve race condition problem
  def find_or_create_team(title) do
    case ForzaAssignment.Repo.get_by(ForzaAssignment.Team, title: title) do
      nil ->
        team = %ForzaAssignment.Team{title: title}
        |> ForzaAssignment.Team.changeset()
        |> ForzaAssignment.Repo.insert
        case team do
          {:ok, persisted_team} -> {:ok, persisted_team}
          {:error, _} -> find_or_create_team(title)
        end
      team -> {:ok, team}
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
