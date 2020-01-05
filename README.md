# ForzaAssignment

## Requirements

Docker & docker-compose

## Installation

```
make setup
```

## Usage

```
make start
```
It runs `mix run --no-halt` command within docker container

## Check results

You can run SQL query on `forza_assignment_repo` db:
```
SELECT matches.id, home_teams.title AS home_team, away_teams.title AS away_team, created_at, kickoff_at, providers.title FROM matches
INNER JOIN teams AS home_teams ON matches.home_team_id = home_teams.id
INNER JOIN teams AS away_teams ON matches.away_team_id = away_teams.id
INNER JOIN providers ON matches.provider_id = providers.id;
```
