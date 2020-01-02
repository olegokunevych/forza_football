defmodule ForzaAssignment.Repo.Migrations.AddUniqueIndexToMatches do
  use Ecto.Migration

  def change do
    create unique_index(:matches, [:provider, :home_team, :away_team, :kickoff_at])
  end
end
