defmodule TurmsWeb.AuthController do
  use TurmsWeb, :controller
  alias TurmsWeb.Plugs.Response
  alias TurmsWeb.Plugs.Authentification

  # API to allow users to connect or create account.
  def login_or_signup(conn, %{"vanity" => vanity} = params) do
    case Turms.Repo.get_by(Turms.User, vanity: vanity) do
      nil ->
        create_new_user(conn, vanity)

      user ->
        handle_existing_user(conn, user, params)
    end
  end

  defp create_new_user(conn, vanity) do
    attrs = %{
      vanity: vanity,
      name: vanity,
      password: nil,
      public: true
    }

    changeset = Turms.User.changeset(%Turms.User{}, attrs)
    Turms.Repo.insert(changeset)

    Response.success(conn, Authentification.generate(vanity), :created)
  end

  defp handle_existing_user(conn, user, %{"password" => password}) do
    case user.hashed_password do
      nil ->
        Response.success(conn, Authentification.generate(user.vanity))

      hashed_password ->
        verify_password(conn, password, hashed_password, user.vanity)
    end
  end

  defp handle_existing_user(conn, user, _params) do
    Response.success(conn, Authentification.generate(user.vanity))
  end

  defp verify_password(conn, password, hashed_password, vanity) do
    if !password or !Argon2.verify_pass(password, hashed_password) do
      Response.error(conn, "Invalid password.", :unauthorized)
    else
      Response.success(conn, Authentification.generate(vanity))
    end
  end
end
