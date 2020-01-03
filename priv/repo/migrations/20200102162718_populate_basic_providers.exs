defmodule ForzaAssignment.Repo.Migrations.PopulateBasicProviders do
  use Ecto.Migration

  def change do
    %ForzaAssignment.Provider{title: "FastBall"}
    |> ForzaAssignment.Repo.insert

    %ForzaAssignment.Provider{title: "Matchbeam"}
    |> ForzaAssignment.Repo.insert
  end
end
