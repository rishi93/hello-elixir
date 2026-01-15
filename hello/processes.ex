defmodule Hello do
  def greet(name) do
    name =
      name
      |> String.capitalize()

    "Hello, #{name}!"
  end
end

defmodule Sender do
  def start(worker, listener) do
    spawn(fn -> loop(worker, listener) end)
  end

  defp loop(worker, listener) do
    send(worker, {:add, [rand(), rand()], listener})
    Process.sleep(1_000)
    loop(worker, listener)
  end

  defp rand() do
    :rand.uniform(10)
  end
end

defmodule AsyncMath do
  def start() do
    spawn(fn -> listen() end)
  end

  def listen() do
    IO.puts("AsyncMath listening")

    # Listen for messages
    receive do
      # Respond to this message
      {:add, [x, y], pid} ->
        IO.puts("AsyncMath received message")
        send(pid, {:result, add(x, y)})
    end

    # Go back to listening
    listen()
  end

  def add(x, y) do
    x + y
  end
end

defmodule Listener do
  def start() do
    spawn(fn -> listen() end)
  end

  def listen() do
    IO.puts("Listening for messages...")

    receive do
      {:result, result} ->
        IO.puts("Received result #{result}")
    end

    # Go back to listening
    listen()
  end
end
