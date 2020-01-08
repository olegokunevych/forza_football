defmodule ForzaAssignment.Providers.Common do
  @moduledoc "Common helpers module"
  def kickoff_at(match) do
    {:ok, kickoff_at, 0} = DateTime.from_iso8601(match["kickoff_at"])
    kickoff_at
  end

  def created_at(match) do
    {:ok, created_at} = DateTime.from_unix(match["created_at"])
    created_at
  end
end
