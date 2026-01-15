defmodule AsyncMath do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: {:via, Registry, {MyRegistry, name}})
  end

  def add(server, x, y) do
    GenServer.call(server, {:add, [x, y]})
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

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: {:via, Registry, {MyRegistry, name}})
  end

  @impl true
  def init(state) do
    IO.puts("Listener started")
    {:ok, state}
  end

  @impl true
  def handle_cast({:result, result}, state) do
    IO.puts("Listener received result #{result}")
    {:noreply, state}
  end
end

defmodule Sender do
  use GenServer

  def start_link({worker, listener}) do
    GenServer.start_link(__MODULE__, {worker, listener})
  end

  @impl true
  def init({worker, listener}) do
    schedule_tick()
    {:ok, {worker, listener}}
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
      {AsyncMath, :math1},
      {Listener, :listener1},
      {Sender,
       {{:via, Registry, {MyRegistry, :math1}}, {:via, Registry, {MyRegistry, :listener1}}}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
