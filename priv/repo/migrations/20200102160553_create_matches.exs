defmodule ForzaAssignment.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :provider_id, :integer
      add :home_team_id, :integer
      add :away_team_id, :integer

      add :kickoff_at, :timestamp
      add :created_at, :timestamp
    end

    create unique_index(:matches, [:provider_id, :home_team_id, :away_team_id, :kickoff_at])
  end
end
