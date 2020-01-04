import Config

config :forza_assignment, ForzaAssignment.Repo,
  database: "forza_assignment_repo",
  username: "postgres",
  password: "",
  hostname: "postgres",
  pool_size: 1000
