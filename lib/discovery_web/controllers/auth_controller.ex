defmodule TurmsWeb.AuthController do
  use TurmsWeb, :controller
  alias TurmsWeb.Plugs.Response
  alias TurmsWeb.Plugs.Authentification

  # API to allow users to connect or create account.
  def login_or_signup(conn, %{"vanity" => vanity} = params) do
    user = Turms.Repo.get_by(Turms.User, vanity: vanity)

    case user do
      nil ->
        # Create new user into database.
        attrs = %{
          vanity: vanity,
          name: vanity,
          password: nil,
          public: true
        }

        changeset = Turms.User.changeset(%Turms.User{}, attrs)
        Turms.Repo.insert(changeset)

        Response.success(conn, Authentification.generate(vanity), :created)

      user ->
        password = Map.get(params, "password", nil)

        case user.hashed_password do
          nil ->
            Response.success(conn, Authentification.generate(vanity))

          hashed_password ->
            if !password or !Argon2.verify_pass(password, hashed_password) do
              Response.error(conn, "Invalid password.", :unauthorized)
            else
              Response.success(conn, Authentification.generate(vanity))
            end
        end
    end
  end
end
