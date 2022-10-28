defmodule Gravitalia.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.Gravitalia
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    if Map.has_key?(payload, "t") do
      case String.downcase(payload["t"]) do
        "ping" ->
          {:reply, {:text, Jason.encode!(%{op: 10, t: "PONG"})}, state, :hibernate}
        "connect" ->
          if payload["d"]["token"] do
            {:reply, {:text, Jason.encode!(%{op: 1, t: "CONNECTED", d: 400000})}, state, :hibernate}
          else
            {:reply, {:close, 3000, <<"Invalid token">>}, state}
          end
        "message" ->
          if payload["d"] do
            message = payload["d"]["message"]
            IO.puts("Received message: #{message}")

            Registry.Gravitalia
            |> Registry.dispatch(state.registrykey, fn(entries) ->
              for {pid, } <- entries do
                if pid != self() do
                  Process.send(pid, message, [])
                end
              end
            end)

            {:reply, {:text, message}, state}
          else
            {:reply, {:text, "No message"}, state}
          end
        "close" ->
          {:reply, {:close, 1000}, state}
        _ ->
          {:reply, {:text, "Unsupported Event"}, state}
      end
    else
      {:reply, {:close, 1003, <<"No Event">>}, state}
    end
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
