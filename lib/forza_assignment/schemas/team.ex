defmodule ForzaAssignment.Team do
  use Ecto.Schema

  schema "teams" do
    field :title, :string
  end

  def changeset(team, params \\ %{}) do
    team
    |> Ecto.Changeset.cast(params, [:title])
    |> Ecto.Changeset.validate_required([:title])
    |> Ecto.Changeset.unique_constraint(:title)
  end
end
