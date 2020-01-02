defmodule ForzaAssignment.Match do
  use Ecto.Schema

  schema "matches" do
    field :provider, :string
    field :home_team, :string
    field :away_team, :string
    field :kickoff_at, :utc_datetime
    field :created_at, :utc_datetime
  end

  def changeset(match, params \\ %{}) do
    match
    |> Ecto.Changeset.cast(params, [:id, :provider, :home_team, :away_team, :kickoff_at, :created_at])
    |> Ecto.Changeset.validate_required([:provider, :home_team, :away_team, :kickoff_at, :created_at])
    |> Ecto.Changeset.unique_constraint(:id, name: :matches_provider_home_team_away_team_kickoff_at_index)
  end
end
