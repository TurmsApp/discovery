defmodule TurmsWeb.MessageController do
  use TurmsWeb, :controller
  require Logger
  alias TurmsWeb.Plugs.Response
  alias Turms.Repo
  alias Turms.Message

  @server Application.compile_env(:discovery, TurmsWeb.Endpoint)[:url][:host]

  @doc """
  Save a message in the database.
  """
  @spec save(String.t(), String.t(), String.t()) :: :ok | {:error, term()}
  def save(sender, recipient, content) do
    # Check if recipient is SHA256(-like) hashed.
    if String.match?(sender, ~r/^[A-Fa-f0-9]{64}$/) do
      {:error, :invalid_sender}
    else
      with [vanity, server] <- TurmsWeb.Plugs.Message.split_vanity(recipient),
           true <- server == @server do
        attrs = %{
          from: sender,
          content: content,
          user_vanity: vanity
        }

        changeset = Message.changeset(%Message{}, attrs)

        case Repo.insert(changeset) do
          {:ok, _record} ->
            :ok

          {:error, changeset} ->
            Logger.error(
              "Failed to insert message: #{inspect(changeset.errors)}"
            )

            {:error, :db_error}
        end
      else
        _ ->
          {:error, :invalid_recipient}
      end
    end
  end

  @doc """
  Endpoint to receive a message from a client.
  A client can usurp a sender, recipient will check message.

  ## HTTP Params
    - sender : String - Message sender.
    - recipient : String - Message recipient.
    - message : String - Encrypted message content.
  """
  def receive(conn, %{
        "sender" => sender,
        "recipient" => recipient,
        "message" => msg
      }) do
    case save(sender, recipient, msg) do
      :ok ->
        Logger.debug("Message from #{sender} to #{recipient} saved.")
        Response.success(conn, %{status: :message_saved}, :ok)

      {:error, reason} ->
        Logger.error("Failed to save message: #{reason}")
        Response.success(conn, %{status: :message_failed}, :ok)
    end
  end
end
