defmodule ForzaAssignment.Providers.Common.CommonTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Providers.Common

  describe "kickoff_at(match)" do
    @tag :skip
    test "it returns kickoff time in timestamp format" do
      match = %{kickoff_at: "2020-01-26T11:00:00Z"}
      {:ok, timestamp, 0} = DateTime.from_iso8601(match["kickoff_at"])

      assert timestamp = Common.kickoff_at(match)
    end
  end

  describe "created_at(match)" do
    @tag :skip
    test "it returns created at time in timestamp format" do
      match = %{created_at: 1_578_246_528}
      {:ok, timestamp} = DateTime.from_unix(match["created_at"])

      assert timestamp = Common.created_at(match)
    end
  end
end
