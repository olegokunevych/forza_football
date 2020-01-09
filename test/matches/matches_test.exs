defmodule ForzaAssignment.Matches.Matches.MatchesTests do
  # use ExUnit.Case
  use ForzaAssignment.RepoCase

  alias ForzaAssignment.Matches.Matches
  alias ForzaAssignment.Matches.Match

  describe "build_match(provider_id, match, home_team_id, away_team_id)" do
    test "it build match object with valid attributes" do
      {:ok, provider} = create_test_provider()

      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Home Team")
      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      match = %{"kickoff_at" => "2020-01-26T11:00:00Z", "created_at" => 1_578_246_528}
      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      expected_match = %ForzaAssignment.Matches.Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      actual_match = Matches.build_match(provider.id, match, home_team.id, away_team.id)

      assert expected_match = actual_match
    end

    test "it build match object with empty attributes" do
      expected_match = %ForzaAssignment.Matches.Match{
        provider_id: nil,
        home_team_id: nil,
        away_team_id: nil,
        kickoff_at: nil,
        created_at: nil
      }

      actual_match = Matches.build_match(nil, nil, nil, nil)

      assert expected_match = actual_match
    end
  end

  describe "persist(match_object)" do
    test "it persists valid match" do
      {:ok, provider} = create_test_provider()

      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Home Team")
      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:ok, match_object} = Matches.persist(match_object)
    end

    test "it persists valid match once" do
      {:ok, provider} = create_test_provider()

      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Home Team")
      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:ok, match_object} = Matches.persist(match_object)

      new_match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Matches.persist(new_match_object)
      assert changeset.errors[:id] == {"has already been taken", [constraint: :unique, constraint_name: "matches_provider_id_home_team_id_away_team_id_kickoff_at_index"]}
    end

    test "it doesn't persist match without provider" do
      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Home Team")
      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Matches.persist(match_object)
      assert changeset.errors[:provider_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without home team" do
      {:ok, provider} = create_test_provider()

      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Matches.persist(match_object)
      assert changeset.errors[:home_team_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without away team" do
      {:ok, provider} = create_test_provider()

      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")
      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        kickoff_at: kickoff_at,
        created_at: created_at
      }

      assert {:error, changeset} = Matches.persist(match_object)
      assert changeset.errors[:away_team_id] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without kickoff_at" do
      {:ok, provider} = create_test_provider()

      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Home Team")
      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, created_at} = DateTime.from_unix(1_578_246_528)

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        created_at: created_at
      }

      assert {:error, changeset} = Matches.persist(match_object)
      assert changeset.errors[:kickoff_at] == {"can't be blank", [validation: :required]}
    end

    test "it doesn't persist match without created_at" do
      {:ok, provider} = create_test_provider()

      {:ok, home_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Home Team")
      {:ok, away_team} = ForzaAssignment.Teams.Teams.find_or_create_team("Away Team")

      {:ok, kickoff_at, 0} = DateTime.from_iso8601("2020-01-26T11:00:00Z")

      match_object = %Match{
        provider_id: provider.id,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        kickoff_at: kickoff_at,
      }

      assert {:error, changeset} = Matches.persist(match_object)
      assert changeset.errors[:created_at] == {"can't be blank", [validation: :required]}
    end
  end

  describe "kickoff_at(match)" do
    @tag :skip
    test "it returns kickoff time in timestamp format" do
      match = %{kickoff_at: "2020-01-26T11:00:00Z"}
      {:ok, timestamp, 0} = DateTime.from_iso8601(match["kickoff_at"])

      assert timestamp = Matches.kickoff_at(match)
    end
  end

  describe "created_at(match)" do
    @tag :skip
    test "it returns created at time in timestamp format" do
      match = %{created_at: 1_578_246_528}
      {:ok, timestamp} = DateTime.from_unix(match["created_at"])

      assert timestamp = Matches.created_at(match)
    end
  end

  defp create_test_provider do
    %ForzaAssignment.Providers.Provider{title: "TestProvider"}
    |> ForzaAssignment.Providers.Provider.changeset()
    |> ForzaAssignment.Repo.insert
  end
end
