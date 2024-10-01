defmodule TurmsWeb.AuthController do
  use TurmsWeb, :controller

  # API to allow users to connect or create account.
  def login_or_signup(conn, %{"vanity" => vanity} = params) do
    user = Turms.Repo.get_by(Turms.User, vanity: vanity)

    case user do
      nil ->
        conn
        |> put_status(:created)
        |> json(%{message: "Hello, World!", status: "success"})

      user ->
        password = Map.get(params, "password", nil)
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Hello, World!", status: "success", password: password})
    end
  end
end
