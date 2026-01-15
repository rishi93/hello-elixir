defmodule Rishi do
  @doc """
  Print "Hello, world!" to the console
  """
  def say_hello do
    IO.puts("Hello, world!")
  end

  @doc """
  Return the lines of a file in a list
  """
  def open_file(filename) do
    case File.read(filename) do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)

      {:error, reason} ->
        IO.puts("Could not open file #{filename}. #{reason}")
    end
  end

  @doc """
  Get n random numbers between 1 and 100
  """
  def random_numbers(n) do
    1..n |> Enum.map(fn _ -> :rand.uniform(100) end)
  end
end
