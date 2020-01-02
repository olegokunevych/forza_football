defmodule ForzaAssignment.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :provider, :string
      add :home_team, :string
      add :away_team, :string
      add :kickoff_at, :timestamp
      add :created_at, :timestamp
    end
  end
end
