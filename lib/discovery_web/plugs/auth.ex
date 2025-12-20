defmodule TurmsWeb.Plugs.Authentification do
  @moduledoc """
  Handle JWT verification.
  """

  use Joken.Config, default_signer: nil

  @issuer "https://turms.gravitalia.com"
  @audience "discovery"
  @jwks_url "#{@issuer}/.well-known/jwks.json"

  add_hook(JokenJwks, jwks_url: @jwks_url)

  @impl true
  def token_config do
    %{}
    |> add_claim("iss", fn -> nil end, &(&1 == @issuer))
    |> add_claim("aud", fn -> nil end, &(&1 == @audience))
    |> add_claim("exp", fn -> nil end, &(Joken.current_time() > &1))
  end

  # Connect via Autha instance using Turms website.
  def connect(token) do
    config = token_config()

    case Joken.verify_and_validate(config, token) do
      {:ok, claims} ->
        [user_id | _server] = TurmsWeb.Plugs.Message.split_vanity(Map.get(claims, "sub"))

        case Turms.Repo.get_by(Turms.User, vanity: user_id) do
          nil ->
            attrs = %{
              vanity: user_id,
              name: user_id
            }

            changeset = Turms.User.changeset(%Turms.User{}, attrs)

            case Turms.Repo.insert(changeset) do
              {:ok, user} ->
                {:ok, user}

              {:error, changeset} ->
                {:error, {:db_error, changeset}}
            end

          user ->
            {:ok, user}
        end

      {:error, reason} ->
        {:error, {:auth_error, reason}}
    end
  end
end
