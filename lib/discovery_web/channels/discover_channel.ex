defmodule TurmsWeb.DiscoverChannel do
  require Logger
  use TurmsWeb, :channel

  @impl true
  def join("discover:lobby", _payload, socket) do
    Logger.debug("#{socket.assigns.user_id} is now on lobby.")

    # After join, send awaiting messages.
    # After send, messages are retained for 5 minute in case of non-receive.
    # After retention, they are deleted.
    send(self(), :after_join)

    # Always allow a client to join this channel.
    {:ok, socket}
  end

  # Get every pending messages and send them.
  # Messages sent are retained 5 minutes.
  @impl true
  def handle_info(:after_join, socket) do
    push(socket, "pending_messages", [])
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (discover:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
