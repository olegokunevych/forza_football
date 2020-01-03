defmodule ForzaAssignment.Repo.Migrations.CreateProviders do
  use Ecto.Migration

  def change do
    create table(:providers) do
      add :title, :string
    end

    create unique_index(:providers, [:title])
  end
end
