defmodule ForzaAssignment.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :title, :string
    end

    create unique_index(:teams, [:title])
  end
end
