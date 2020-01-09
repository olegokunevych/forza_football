defmodule ForzaAssignment.Providers.Providers.ProvidersTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Providers.Providers
  alias ForzaAssignment.Providers.Provider

  describe "provider_id_by_title" do
    test "it returns provider id by provider title" do
      provider_title = "TestProvider"
      {:ok, %Provider{id: provider_id}} = %Provider{title: provider_title}
      |> Provider.changeset()
      |> ForzaAssignment.Repo.insert

      assert provider_id = Providers.provider_id_by_title(provider_title)
    end

    test "it returns nil when provider not found" do
      provider_title = "NonExistingProvider"

      assert is_nil(Providers.provider_id_by_title(provider_title))
    end
  end

end
