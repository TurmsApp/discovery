defmodule TurmsWeb.DiscoverChannel do
  require Logger
  use TurmsWeb, :channel
  alias TurmsWeb.MessageController

  @server Application.compile_env(:discovery, TurmsWeb.Endpoint)[:url][:host]

  @impl true
  def join("", _payload, socket) do
    Logger.debug("#{socket.assigns.user_id} is now on lobby.")

    # After join, send awaiting messages.
    # After send, server waits a receipt and then, delete messages on database.
    send(self(), :after_join)

    # Always allow a client to join this channel.
    {:ok, socket}
  end

  # Get every pending messages and send them.
  # Messages sent are retained 5 minutes.
  @impl true
  def handle_info(:after_join, socket) do
    messages = Turms.Repo.get_by(Turms.Message, user_vanity: socket.assigns.user_id)

    IO.inspect(messages)

    push(socket, "pending_messages", [])
    {:noreply, socket}
  end

  # Handle ingoing PING requests.
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Handle ingoing SDP set requests.
  @impl true
  def handle_in("sdp", %{"sdp" => sdp}, socket) do
    Turms.Cache.Sdp.set(socket.assigns.user_id, sdp)
    {:reply, {:ok}, socket}
  end

  # Save message when recipient is not online.
  @impl true
  def handle_in("message", %{"content" => content, "recipient" => recipient}, socket) do
    case TurmsWeb.Plugs.Message.split_vanity(recipient) do
      [_vanity, server] ->
        handle_server_match(server, recipient, content, socket)

      _ ->
        push_invalid_recipient(socket)
    end
  end

  defp handle_server_match(server, recipient, content, socket) when server == @server do
    hashed_user_id =
      socket.assigns.user_id
      |> to_string()
      |> :crypto.hash(:sha256)
      |> Base.encode16(case: :lower)

    case MessageController.save(hashed_user_id, recipient, content) do
      :ok ->
        Logger.debug("Message from #{socket.assigns.user_id} to #{recipient} saved.")
        push(socket, "message", %{error: false, message: ""})

      {:error, reason} ->
        Logger.error("Failed to save message (WS): #{reason}")
        push(socket, "message", %{error: true, message: "Internal server error."})
    end
  end

  defp handle_server_match(_server, _recipient, _content, socket) do
    push(socket, "message", %{error: true, message: "Recipient doesn't use the same server"})
  end

  defp push_invalid_recipient(socket) do
    push(socket, "message", %{error: true, message: "Invalid 'recipient'."})
  end
end
