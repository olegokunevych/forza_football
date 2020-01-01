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

      # Starts a worker by calling: ForzaAssignment.Worker.start_link(arg)
      # {ForzaAssignment.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ForzaAssignment.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
