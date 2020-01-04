defmodule ForzaAssignment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ForzaAssignment.Producer,
      ForzaAssignment.Splitter,
      ForzaAssignment.ConsumerMatchbeam,
      ForzaAssignment.ConsumerFastBall,
      {ForzaAssignment.Repo, []}
    ]

    :ets.new(:last_checked_at, [:set, :named_table, :public, read_concurrency: true,
                                                 write_concurrency: true])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ForzaAssignment.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
