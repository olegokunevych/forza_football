defmodule ForzaAssignment.Providers.Matchbeam.Manager do
  @url "http://forzaassignment.forzafootball.com:8080/feed/matchbeam"

  def call do
    ForzaAssignment.Utils.Fetch.call(@url)
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.each(fn match -> IO.inspect(match) end)
    |> Enum.to_list
  end
end
