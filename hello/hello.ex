defmodule Hello do
  def read_file(filename) do
    case File.read(filename) do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)

      {:error, reason} ->
        IO.puts("Could not read file. #{reason}")
        :error
    end
  end

  def compare_number_cond(number) do
    # This function won't work with 0
    # cond always needs one of it's clauses to be true
    cond do
      number < 0 -> IO.puts("It's a negative number")
      number > 0 -> IO.puts("It's a positive number")
    end
  end

  def compare_number_if(number) do
    # This function will work for all numbers
    # if doesn't care if the clause isn't true
    if number < 0 do
      IO.puts("It's a negative number")
    end

    if number > 0 do
      IO.puts("It's a positive number")
    end
  end

  def read_file_case(map) do
    case Map.fetch(map, :name) do
      {:ok, val} ->
        case File.read(val) do
          {:ok, contents} ->
            contents
            |> String.split("\n", trim: true)

          {:error, reason} ->
            IO.puts("Could not read file. #{reason}")
        end

      :error ->
        IO.puts("No key :name in the map")
    end
  end

  def read_file_with(map) do
    with {:ok, name} <- Map.fetch(map, :name),
         {:ok, contents} <- File.read(name) do
      contents
      |> String.split("\n", trim: true)
    else
      :error -> IO.puts("No key :name found")
      {:error, reason} -> IO.puts("Could not read file. #{reason}")
    end
  end
end
