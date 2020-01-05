defmodule ForzaAssignment.MixProject do
  use Mix.Project

  def project do
    [
      app: :forza_assignment,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto],
      mod: {ForzaAssignment.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 0.14"},
      {:flow, "~> 0.14.0"},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:bypass, "~> 1.0", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      "ecto.setup": ["ecto.create -r ForzaAssignment.Repo", "ecto.migrate -r ForzaAssignment.Repo"],
      "ecto.reset": ["ecto.drop -r ForzaAssignment.Repo", "ecto.setup"],
      test: ["ecto.reset", "test"]
    ]
  end
end
