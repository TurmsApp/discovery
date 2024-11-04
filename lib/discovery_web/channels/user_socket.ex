defmodule TurmsWeb.UserSocket do
  require Logger
  use Phoenix.Socket

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  channel("*", TurmsWeb.DiscoverChannel)

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error` or `{:error, term}`. To control the
  # response the client receives in that case, [define an error handler in the
  # websocket
  # configuration](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#socket/3-websocket-configuration).
  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    {ok, claims} = Joken.verify_and_validate(TurmsWeb.Plugs.Authentification.claims(""), token)

    if ok == :ok do
      user_id = Map.get(claims, "sub")

      Logger.debug("#{user_id} is now connected.")

      # Assign user_id to socket
      socket = assign(socket, :user_id, user_id)

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Socket IDs are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.TurmsWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(socket), do: socket.assigns.user_id
end
