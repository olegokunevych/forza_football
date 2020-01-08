defmodule ForzaAssignment.Teams.Team do
  @moduledoc "Team persisting"
  use Ecto.Schema

  schema "teams" do
    field :title, :string
  end

  def changeset(team, params \\ %{}) do
    team
    |> Ecto.Changeset.cast(params, [:title])
    |> Ecto.Changeset.validate_required([:title])
    |> Ecto.Changeset.unique_constraint(:title)
  end

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
