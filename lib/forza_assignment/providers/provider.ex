defmodule ForzaAssignment.Providers.Provider do
  @moduledoc "Provider persisting"
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

  def provider_id_by_title(title) do
    provider = ForzaAssignment.Repo.get_by(ForzaAssignment.Providers.Provider, title: title)
    case provider do
      nil -> nil
      _ -> provider.id
    end
  end
end
