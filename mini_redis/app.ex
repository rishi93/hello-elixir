defmodule MiniRedis do
  use GenServer

  # The GenServer process starts with this state
  # Use this guard to make sure that state is a map
  def init(state) when is_map(state) do
    {:ok, state}
  end

  # Called by the main process, to start the GenServer process
  def start_link(state) do
    # __MODULE__ resolves to MiniRedis inside the MiniRedis module
    GenServer.start_link(__MODULE__, state)
  end

  # These functions are the public API, and are called by the caller's process
  def set(pid, key, value) do
    GenServer.call(pid, {:set, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  # These functions run inside the GenServer process
  def handle_call({:set, key, value}, _from, state) do
    {:reply, :ok, Map.merge(state, %{key => value})}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch(state, key), state}
  end
end
