defprotocol Printable do
  # A protocol is something you implement later
  # Something like an interface if you're familiar
  # with OOP languages
  def to_csv(data)
end

defimpl Printable, for: Map do
  def to_csv(map) do
    map
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join(",")
  end
end

defimpl Printable, for: List do
  def to_csv(list) do
    list
    |> Enum.map(fn item -> Printable.to_csv(item) end)
    |> Enum.join(",")
  end
end

defimpl Printable, for: Integer do
  def to_csv(int) do
    int |> to_string
  end
end
