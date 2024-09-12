defmodule TurmsWeb.Plugs.Authentification do
  @moduledoc """
  Generate and verify connection tokens.
  """
  alias TurmsWeb.Auth

  use Joken.Config

  @hour_in_seconds 60 * 60

  @spec claims(String.t()) :: %{optional(binary()) => Joken.Claim.t()}
  def claims(user_id) do
    issuer = Application.get_env(:discovery, :app_config)[:host]
    expire = Joken.current_time() + @hour_in_seconds

    default_claims(
      skip: [:nbf, :jti],
      iss: issuer,
      iat: Joken.current_time(),
      exp: expire,
      aud: user_id
    )
  end

  @spec verify(String.t()) :: nil | String.t()
  def verify(token) do
    signer = Joken.Signer.create("HS256", "your_secret_key")

    case Joken.Signer.verify(token, signer) do
      {:ok, claims} ->
        cond do
          :os.system_time(:millisecond) / 1000 >= Map.get(claims, "exp") ->
            nil

          Map.get(claims, "iss") != Application.get_env(:discovery, :app_config)[:host] ->
            nil

          true ->
            Map.get(claims, "sub")
        end

      {:error, _reason} ->
        nil
    end
  end

  @spec generate(String.t()) :: String.t()
  def generate(user_id) do
    signer = Joken.Signer.parse_config()

    {ok, token, _claims} = Joken.generate_and_sign(claims(user_id), signer)

    if ok != :ok do
      ""
    else
      token
    end
  end
end
