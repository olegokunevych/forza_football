defmodule ForzaAssignment.Teams.Team.TeamTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Teams.Team

  describe "find_or_create_team(title)" do
    test "it returns team if team is already exist" do
      team_title = "TestTeam"
      {:ok, existing_team} = %Team{title: team_title}
      |> Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, team} = Team.find_or_create_team(team_title)

      assert existing_team = team
    end

    test "it returns a new team if team is non existing" do
      team_title = "TestTeam"

      assert {:ok, %Team{title: team_title}} = Team.find_or_create_team(team_title)
    end
  end
end
