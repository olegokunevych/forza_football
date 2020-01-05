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

If you want to use local instance of Postgres, instead of one from docker, you need to remove `hostname: "postgres",` line in `config/test.exs` and `config/dev.exs`

## Tests

```
make tests
```

## Check results

You can run SQL query on `forza_assignment_repo` db:
```
SELECT matches.id, home_teams.title AS home_team, away_teams.title AS away_team, created_at, kickoff_at, providers.title FROM matches
INNER JOIN teams AS home_teams ON matches.home_team_id = home_teams.id
INNER JOIN teams AS away_teams ON matches.away_team_id = away_teams.id
INNER JOIN providers ON matches.provider_id = providers.id;
```

## Known issues

Run `docker-compose down` if next error occurs:
```
** (Postgrex.Error) FATAL 53300 (too_many_connections) sorry, too many clients already
test_1      |     (db_connection) lib/db_connection/connection.ex:87: DBConnection.Connection.connect/2
test_1      |     (connection) lib/connection.ex:622: Connection.enter_connect/5
test_1      |     (stdlib) proc_lib.erl:249: :proc_lib.init_p_do_apply/3
```