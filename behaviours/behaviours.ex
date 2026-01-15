defmodule TalkingAnimal do
  @callback say(what :: String.t()) :: {:ok}
end

defmodule Cat do
  @behaviour TalkingAnimal
  # We choose to not use what in our behaviour here
  def say(_what) do
    "miao!"
  end
end

defmodule Dog do
  # We choose to use what in our behaviour here
  @behaviour TalkingAnimal
  def say(what) do
    "#{what} woof!"
  end
end

defmodule Factory do
  def get_animal(iq) do
    # Can get module from configuration file
    if iq < 80 do
      Cat
    else
      Dog
    end
  end
end
