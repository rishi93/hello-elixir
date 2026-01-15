defmodule MiniRedis do
  @moduledoc """
  The public facing facade for MiniRedis.Server
  """
  def start_link(initial_state \\ %{}) do
    MiniRedis.Server.start_link(initial_state)
  end

  def set(pid, key, value) do
    MiniRedis.Server.set(pid, key, value)
  end

  def get(pid, key) do
    MiniRedis.Server.get(pid, key)
  end
end

defmodule MiniRedis.Server do
  @moduledoc """
  The MiniRedis GenServer
  """
  use GenServer

  # start_link runs inside the caller's process. Don't do
  # any heavy setup work here since it is blocks the caller
  # start_link only creates the process. init initializes it
  # start_link spawns the process
  def start_link(initial_state) when is_map(initial_state) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def set(pid, key, value) do
    GenServer.cast(pid, {:set, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  # Server callbacks
  # The init method runs inside the new GenServer process
  # Initialize state and do any setup work needed for the
  # process
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:set, key, value}, state) do
    # {status, new_state} nothing is sent back as reply
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    # {status, reply, new_state}
    # we don't modify the state here so that remains as such
    {:reply, Map.fetch(state, key), state}
  end
end
