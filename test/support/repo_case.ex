defmodule ForzaAssignment.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ForzaAssignment.Repo

      import Ecto
      import Ecto.Query
      import ForzaAssignment.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ForzaAssignment.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ForzaAssignment.Repo, {:shared, self()})
    end

    :ok
  end
end
