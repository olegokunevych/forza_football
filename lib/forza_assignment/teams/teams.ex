defmodule ForzaAssignment.Teams.Teams do
  # function implemented to solve race condition problem
  def find_or_create_team(title) do
    case ForzaAssignment.Repo.get_by(ForzaAssignment.Teams.Team, title: title) do
      nil ->
        team = %ForzaAssignment.Teams.Team{title: title}
        |> ForzaAssignment.Teams.Team.changeset()
        |> ForzaAssignment.Repo.insert
        case team do
          {:ok, persisted_team} -> {:ok, persisted_team}
          {:error, _} -> find_or_create_team(title)
        end
      team -> {:ok, team}
    end
  end
end
