defmodule Myapp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: MyRegistry},
      {Worker, [name: {:via, Registry, {MyRegistry, :worker1}}]},
      {Listener, [name: {:via, Registry, {MyRegistry, :listener1}}]},
      {Sender,
       {
         {:via, Registry, {MyRegistry, :worker1}},
         {:via, Registry, {MyRegistry, :listener1}}
       }}
    ]

    opts = [strategy: :one_for_one, name: Myapp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
