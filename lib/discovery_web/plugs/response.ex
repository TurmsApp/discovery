defmodule TurmsWeb.Plugs.Response do
  @moduledoc """
  Handle JSON responses from API.
  """
  use TurmsWeb, :controller

  # Send a success message.
  def success(conn, data, code \\ 200) do
    conn
    |> put_status(code)
    |> json(%{status: "success", data: data, error: nil})
  end

  # Throw an error to the client.
  def error(conn, message, code \\ 400) do
    response = %{
      status: "error",
      data: nil,
      error: message
    }

    conn
    |> put_status(code)
    |> json(response)
  end
end
