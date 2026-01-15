defmodule AsyncMath do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def add(pid, x, y) do
    GenServer.call(pid, {:add, [x, y]})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:add, [x, y]}, _from, state) do
    {:reply, x + y, state}
  end
end

defmodule Listener do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:result, result}, state) do
    IO.puts("Got result #{result}")
    {:noreply, state}
  end
end

defmodule Sender do
  use GenServer

  def start_link({worker, listener}) do
    GenServer.start_link(__MODULE__, {worker, listener})
  end

  @impl true
  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, {worker, listener} = state) do
    x = :rand.uniform(10)
    y = :rand.uniform(10)

    result = AsyncMath.add(worker, x, y)
    GenServer.cast(listener, {:result, result})

    schedule_tick()
    {:noreply, state}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, 1_000)
  end
end

defmodule MyApp.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    children = [
      {Registry, keys: :unique, name: MyRegistry},
      {AsyncMath, [name: {:via, Registry, {MyRegistry, :math1}}]},
      {Listener, [name: {:via, Registry, {MyRegistry, :listener1}}]},
      {Sender,
       {{:via, Registry, {MyRegistry, :math1}}, {:via, Registry, {MyRegistry, :listener1}}}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
