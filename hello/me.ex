defmodule Processes do
  def start() do
    IO.puts("Waiting for message...")

    receive do
      {:add, [x, y], pid} ->
        IO.puts("Received a message. Sending response.")
        send(pid, {:result, add(x, y)})
    end

    start()
  end

  def add(x, y) do
    x + y
  end
end

defmodule Listener do
  def listen() do
    IO.puts("Listening for messages...")

    receive do
      {:result, result} ->
        IO.puts("Heard something")
        IO.puts("Result received: #{result}")
    end

    listen()
  end
end
