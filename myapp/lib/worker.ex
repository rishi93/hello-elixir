defmodule Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def work(server, list) do
    GenServer.call(server, {:work, list})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:work, list}, _from, state) do
    Process.sleep(1_000)
    result = Enum.sum(list)
    {:reply, {:result, result}, state}
  end
end
