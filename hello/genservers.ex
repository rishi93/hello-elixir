defmodule AsyncMath do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
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

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(state) do
    IO.puts("Listener started")
    {:ok, state}
  end

  @impl true
  def handle_info({:result, result}, state) do
    IO.puts("Listener received result: #{result}")
    {:noreply, state}
  end
end

defmodule Sender do
  use GenServer

  def start_link(worker \\ AsyncMath, listener \\ Listener) do
    GenServer.start_link(__MODULE__, {worker, listener})
  end

  @impl true
  def init({worker, listener}) do
    schedule_tick()
    {:ok, {worker, listener}}
  end

  @doc """
  This function is triggered each time the process receives
  a :tick message
  """
  @impl true
  def handle_info(:tick, {worker, listener} = state) do
    x = :rand.uniform(10)
    y = :rand.uniform(10)

    result = AsyncMath.add(worker, x, y)
    send(listener, {:result, result})

    schedule_tick()
    {:noreply, state}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, 1_000)
  end
end
