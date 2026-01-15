defmodule AsyncMath do
  def start() do
    IO.puts("AsyncMath - listening to messages")

    receive do
      {:add, [x, y], pid} ->
        IO.puts("Got work! Doing!")
        send(pid, {:result, add(x, y)})
        IO.puts("Finished doing and sent result!")
    end

    start()
  end

  def add(x, y) do
    x + y
  end
end

defmodule Listener do
  def listen() do
    IO.puts("Listener - listening to messages")

    receive do
      {:result, result} ->
        IO.puts("Got something")
        IO.puts("Got result #{result}")
    end

    listen()
  end
end
