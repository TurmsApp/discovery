defmodule TurmsWeb.Plugs.Authentification do
  @moduledoc """
  Handle JWT verification.
  """

  use Joken.Config, default_signer: nil

  @issuer "https://turms.gravitalia.com"
  @audience "discovery"
  @jwks_url "#{@issuer}/.well-known/jwks.json"

  add_hook(JokenJwks, jwks_url: @jwks_url)

  # Implement default token configuration.
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

    with {:ok, claims} <- Joken.verify_and_validate(config, token),
         user_id <- extract_user_id(claims),
         {:ok, user} <- find_or_create_user(user_id) do
      {:ok, user}
    else
      {:error, reason} -> {:error, {:auth_error, reason}}
    end
  end

  defp extract_user_id(claims) do
    claims
    |> Map.get("sub")
    |> TurmsWeb.Plugs.Message.split_vanity()
    |> List.first()
  end

  defp find_or_create_user(user_id) do
    case Turms.Repo.get_by(Turms.User, vanity: user_id) do
      nil ->
        attrs = %{vanity: user_id, name: user_id}

        %Turms.User{}
        |> Turms.User.changeset(attrs)
        |> Turms.Repo.insert()
        |> case do
          {:ok, user} -> {:ok, user}
          {:error, changeset} -> {:error, {:db_error, changeset}}
        end

      user ->
        {:ok, user}
    end
  end
end
