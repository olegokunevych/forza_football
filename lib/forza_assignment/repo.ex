defmodule ForzaAssignment.Repo do
  use Ecto.Repo,
    otp_app: :forza_assignment,
    adapter: Ecto.Adapters.Postgres
end
