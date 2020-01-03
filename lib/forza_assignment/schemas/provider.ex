defmodule ForzaAssignment.Provider do
  use Ecto.Schema

  schema "providers" do
    field :title, :string
  end

  def changeset(match, params \\ %{}) do
    match
    |> Ecto.Changeset.cast(params, [:id, :title])
    |> Ecto.Changeset.validate_required([:title])
    |> Ecto.Changeset.unique_constraint(:title)
  end
end
