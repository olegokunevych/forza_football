defmodule ForzaAssignment.Providers.CommonTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Providers.Common

  describe "provider_id_by_title" do
    test "it returns provider id by provider title" do
      provider_title = "TestProvider"
      {:ok, %ForzaAssignment.Provider{id: provider_id}} = %ForzaAssignment.Provider{title: provider_title}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      assert provider_id = Common.provider_id_by_title(provider_title)
    end

    test "it returns nil when provider not found" do
      provider_title = "NonExistingProvider"

      assert is_nil(Common.provider_id_by_title(provider_title))
    end
  end

  describe "find_or_create_team(title)" do
    test "it returns team if team is already exist" do
      team_title = "TestTeam"
      {:ok, existing_team} = %ForzaAssignment.Team{title: team_title}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, team} = Common.find_or_create_team(team_title)

      assert existing_team = team
    end

    test "it returns a new team if team is non existing" do
      team_title = "TestTeam"

      assert {:ok, %ForzaAssignment.Team{title: team_title}} = Common.find_or_create_team(team_title)
    end
  end

  describe "kickoff_at(match)" do
    @tag :skip
    test "it returns kickoff time in timestamp format" do
      match = %{ kickoff_at: "2020-01-26T11:00:00Z" }
      {:ok, timestamp, 0} = DateTime.from_iso8601(match["kickoff_at"])

      assert timestamp = Common.kickoff_at(match)
    end
  end

  describe "created_at(match)" do
    @tag :skip
    test "it returns created at time in timestamp format" do
      match = %{ created_at: 1578246528 }
      {:ok, timestamp} = DateTime.from_unix(match["created_at"])

      assert timestamp = Common.created_at(match)
    end
  end

  describe "persist(match_object)" do
    test "it persists valid match" do
      {:ok, provider} = %ForzaAssignment.Provider{title: "TestProvider"}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Team{title: "Home Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Team{title: "Away Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1578246528)

      match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:ok, match_object} = Common.persist(match_object)
    end

    test "it persists valid match once" do
      {:ok, provider} = %ForzaAssignment.Provider{title: "TestProvider"}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Team{title: "Home Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Team{title: "Away Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1578246528)

      match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:ok, match_object} = Common.persist(match_object)

      new_match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Common.persist(new_match_object)
      assert changeset.errors[:id] == {"has already been taken", [constraint: :unique, constraint_name: "matches_provider_id_home_team_id_away_team_id_kickoff_at_index"]}
    end

    test "it doesn't persist match without provider" do
      {:ok, home_team} = %ForzaAssignment.Team{title: "Home Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Team{title: "Away Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1578246528)

      match_object = %ForzaAssignment.Match{
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Common.persist(match_object)
      assert changeset.errors[:provider_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without home team" do
      {:ok, provider} = %ForzaAssignment.Provider{title: "TestProvider"}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Team{title: "Away Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1578246528)

      match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Common.persist(match_object)
      assert changeset.errors[:home_team_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without away team" do
      {:ok, provider} = %ForzaAssignment.Provider{title: "TestProvider"}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Team{title: "Home Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1578246528)

      match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Common.persist(match_object)
      assert changeset.errors[:away_team_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without kickoff_at" do
      {:ok, provider} = %ForzaAssignment.Provider{title: "TestProvider"}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Team{title: "Home Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Team{title: "Away Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, created_at} = DateTime.from_unix(1578246528)

      match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        created_at: created_at
      }

      assert {:error, changeset} = Common.persist(match_object)
      assert changeset.errors[:kickoff_at] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without created_at" do
      {:ok, provider} = %ForzaAssignment.Provider{title: "TestProvider"}
      |> ForzaAssignment.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Team{title: "Home Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Team{title: "Away Team"}
      |> ForzaAssignment.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")

      match_object = %ForzaAssignment.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
      }

      assert {:error, changeset} = Common.persist(match_object)
      assert changeset.errors[:created_at] == {"can't be blank", [validation: :required]}
    end
  end
end
