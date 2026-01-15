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
