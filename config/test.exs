import Config

config :forza_assignment, ForzaAssignment.Repo,
  database: "forza_assignment_repo_test",
  username: "postgres",
  password: "",
  # hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger,
  level: :warn,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]
