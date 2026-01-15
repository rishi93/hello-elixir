defmodule Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def work(pid, list) do
    GenServer.call(pid, {:work, list})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:work, list}, _from, state) do
    Process.sleep(1_000)
    {:reply, Enum.sum(list), state}
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
    IO.puts("Received result #{result}")
    {:noreply, state}
  end
end

defmodule Sender do
  use GenServer

  def start_link({worker, listener}) do
    GenServer.start_link(__MODULE__, {worker, listener})
  end

  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  def handle_info(:tick, {worker, listener} = state) do
    my_list =
      1..10
      |> Enum.map(fn _ -> :rand.uniform(10) end)

    result = GenServer.call(worker, {:work, my_list})
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
      {Worker, [name: {:via, Registry, {MyRegistry, :worker1}}]},
      {Listener, [name: {:via, Registry, {MyRegistry, :listener1}}]},
      {Sender,
       {
         {:via, Registry, {MyRegistry, :worker1}},
         {:via, Registry, {MyRegistry, :listener1}}
       }}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
