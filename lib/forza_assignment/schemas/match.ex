defmodule ForzaAssignment.Match do
  use Ecto.Schema

  schema "matches" do
    field :provider_id, :integer
    # field :home_team_id, :integer
    belongs_to(:home_team, Team, foreign_key: :home_team_id)
    field :away_team_id, :integer
    field :kickoff_at, :utc_datetime
    field :created_at, :utc_datetime
  end

  def changeset(match, params \\ %{}) do
    match
    |> Ecto.Changeset.cast(params, [:id, :provider_id, :home_team_id, :away_team_id, :kickoff_at, :created_at])
    |> Ecto.Changeset.validate_required([:provider_id, :home_team_id, :away_team_id, :kickoff_at, :created_at])
    |> Ecto.Changeset.unique_constraint(:id, name: :matches_provider_id_home_team_id_away_team_id_kickoff_at_index)
  end
end
