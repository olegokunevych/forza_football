defmodule ForzaAssignment.Providers.Providers do
  def provider_id_by_title(title) do
    provider = ForzaAssignment.Repo.get_by(ForzaAssignment.Providers.Provider, title: title)
    case provider do
      nil -> nil
      _ -> provider.id
    end
  end
end
