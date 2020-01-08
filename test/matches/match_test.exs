defmodule ForzaAssignment.Matches.Match.MatchTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Matches.Match

  describe "persist(match_object)" do
    test "it persists valid match" do
      {:ok, provider} = %ForzaAssignment.Providers.Provider{title: "TestProvider"}
      |> ForzaAssignment.Providers.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Teams.Team{title: "Home Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Teams.Team{title: "Away Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:ok, match_object} = Match.persist(match_object)
    end

    test "it persists valid match once" do
      {:ok, provider} = %ForzaAssignment.Providers.Provider{title: "TestProvider"}
      |> ForzaAssignment.Providers.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Teams.Team{title: "Home Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Teams.Team{title: "Away Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:ok, match_object} = Match.persist(match_object)

      new_match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Match.persist(new_match_object)
      assert changeset.errors[:id] == {"has already been taken", [constraint: :unique, constraint_name: "matches_provider_id_home_team_id_away_team_id_kickoff_at_index"]}
    end

    test "it doesn't persist match without provider" do
      {:ok, home_team} = %ForzaAssignment.Teams.Team{title: "Home Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Teams.Team{title: "Away Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Match.persist(match_object)
      assert changeset.errors[:provider_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without home team" do
      {:ok, provider} = %ForzaAssignment.Providers.Provider{title: "TestProvider"}
      |> ForzaAssignment.Providers.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Teams.Team{title: "Away Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Match.persist(match_object)
      assert changeset.errors[:home_team_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without away team" do
      {:ok, provider} = %ForzaAssignment.Providers.Provider{title: "TestProvider"}
      |> ForzaAssignment.Providers.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Teams.Team{title: "Home Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Match.persist(match_object)
      assert changeset.errors[:away_team_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without kickoff_at" do
      {:ok, provider} = %ForzaAssignment.Providers.Provider{title: "TestProvider"}
      |> ForzaAssignment.Providers.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Teams.Team{title: "Home Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Teams.Team{title: "Away Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        created_at: created_at
      }

      assert {:error, changeset} = Match.persist(match_object)
      assert changeset.errors[:kickoff_at] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without created_at" do
      {:ok, provider} = %ForzaAssignment.Providers.Provider{title: "TestProvider"}
      |> ForzaAssignment.Providers.Provider.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, home_team} = %ForzaAssignment.Teams.Team{title: "Home Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, away_team} = %ForzaAssignment.Teams.Team{title: "Away Team"}
      |> ForzaAssignment.Teams.Team.changeset()
      |> ForzaAssignment.Repo.insert

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
      }

      assert {:error, changeset} = Match.persist(match_object)
      assert changeset.errors[:created_at] == {"can't be blank", [validation: :required]}
    end
  end
end
