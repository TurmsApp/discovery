defmodule TurmsWeb.Plugs.Authentification do
  @moduledoc """
  Generate connection tokens.
  Verify token using Joken.verify_and_validate
  """
  alias TurmsWeb.Auth

  use Joken.Config

  @hour_in_seconds 60 * 60
  @issuer Application.compile_env(:discovery, :app_config)[:host] ||
            Atom.to_string(Application.compile_env(:discovery, :namespace))

  @spec claims(String.t()) :: %{optional(binary()) => Joken.Claim.t()}
  def claims(user_id) do
    expire = Joken.current_time() + @hour_in_seconds

    default_claims(
      skip: [:nbf, :jti],
      iss: @issuer,
      iat: Joken.current_time(),
      exp: expire
    )
    |> add_claim("aud", fn -> user_id end, nil)
  end

  @spec generate(String.t()) :: String.t()
  def generate(user_id) do
    {ok, token, _claims} = Joken.generate_and_sign(claims(user_id), %{})

    if ok != :ok do
      ""
    else
      token
    end
  end
end
