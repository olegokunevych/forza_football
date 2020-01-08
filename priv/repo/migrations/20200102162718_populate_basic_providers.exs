defmodule ForzaAssignment.Repo.Migrations.PopulateBasicProviders do
  use Ecto.Migration

  def change do
    %ForzaAssignment.Providers.Provider{title: "FastBall"}
    |> ForzaAssignment.Repo.insert

    %ForzaAssignment.Providers.Provider{title: "Matchbeam"}
    |> ForzaAssignment.Repo.insert
  end
end
