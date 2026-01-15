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

    msg = GenServer.call(worker, {:work, my_list})
    GenServer.cast(listener, msg)
    schedule_tick()

    {:noreply, state}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, 1_000)
  end
end
