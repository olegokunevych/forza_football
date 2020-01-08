defmodule ForzaAssignment.Matches.Match do
  @moduledoc false
  use Ecto.Schema

  schema "matches" do
    field :provider_id, :integer
    belongs_to(:home_team, ForzaAssignment.Teams.Team, foreign_key: :home_team_id)
    belongs_to(:away_team, ForzaAssignment.Teams.Team, foreign_key: :away_team_id)
    field :kickoff_at, :utc_datetime
    field :created_at, :utc_datetime
  end

  def changeset(match, params \\ %{}) do
    match
    |> Ecto.Changeset.cast(params, [:id, :provider_id, :home_team_id, :away_team_id, :kickoff_at, :created_at])
    |> Ecto.Changeset.validate_required([:provider_id, :home_team_id, :away_team_id, :kickoff_at, :created_at])
    |> Ecto.Changeset.unique_constraint(:id, name: :matches_provider_id_home_team_id_away_team_id_kickoff_at_index)
  end

  def persist(match_object) do
    ForzaAssignment.Matches.Match.changeset(match_object, %{})
    |> ForzaAssignment.Repo.insert
  end
end
