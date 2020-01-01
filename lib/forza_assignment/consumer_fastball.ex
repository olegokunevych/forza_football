defmodule ForzaAssignment.ConsumerFastBall do
  use GenStage

  @min_demand 0
  @max_demand 1

  def start_link, do: start_link([])
  def start_link(_), do: GenStage.start_link(__MODULE__, :ok)

  def init(:ok) do
    state = %{producer_consumer: ForzaAssignment.Splitter, subscription: nil}

    {
      :consumer,
      state,
      subscribe_to: [{
        ForzaAssignment.Splitter,
        partition: :FastBall,
        min_demand: @min_demand,
        max_demand: @max_demand
      }]
     }
  end

  def handle_subscribe(:producer, _opts, from, state) do
    {:automatic, Map.put(state, :subscription, from)}
  end

  def handle_info(:init_ask, %{subscription: subscription} = state) do
    GenStage.ask(subscription, @max_demand)

    {:noreply, [], state}
  end
  def handle_info(_, state), do: {:noreply, [], state}

  def handle_events(events, _from, %{subscription: _subscription} = state)
      when is_list(events)
  do
    # events handling here
    IO.puts("Consumer FastBall events dispatching:")
    IO.inspect(events)

    {:noreply, [], state}
  end
  def handle_events(events, _from, state) do
    IO.inspect(events)
    {:noreply, [], state}
  end
end
