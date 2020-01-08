defmodule ForzaAssignment.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :forza_assignment,
    adapter: Ecto.Adapters.Postgres
end
