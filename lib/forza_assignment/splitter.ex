defmodule ForzaAssignment.Splitter do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = %{producer: ForzaAssignment.Producer}
    hash_fun = fn event ->
      {event, case event do
                 "Matchbeam" -> :Matchbeam
                 "FastBall" -> :FastBall
                 _ -> raise("Unsupported provider")
               end
      } end
    {:producer_consumer, state,
      subscribe_to: [{ForzaAssignment.Producer, max_demand: 4}],
      dispatcher: {GenStage.PartitionDispatcher,
                    partitions: [:Matchbeam, :FastBall],
                    hash: hash_fun}
    }
  end
  def handle_events(events, _from, state) do
    {:noreply, events, state}
  end
end
