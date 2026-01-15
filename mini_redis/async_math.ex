defmodule AsyncMath do
  def start_link(initial_state \\ %{}) do
    AsyncMath.Server.start_link(initial_state)
  end

  def add(pid, x, y) do
    AsyncMath.Server.add(pid, x, y)
  end
end

defmodule AsyncMath.Server do
  use GenServer

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state)
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
