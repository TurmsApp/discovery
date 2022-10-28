defmodule Gravitalia do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Gravitalia.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.Gravitalia
      )
    ]

    opts = [strategy: :one_for_one, name: Gravitalia.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/", Gravitalia.SocketHandler, []}
        ]
      }
    ]
  end
end
