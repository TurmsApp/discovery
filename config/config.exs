# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :discovery,
  namespace: Turms,
  ecto_repos: [Turms.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :discovery, TurmsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TurmsWeb.ErrorHTML, json: TurmsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Turms.PubSub,
  live_view: [signing_salt: "nZVxVOb4"]

# Configure JWT.
config :joken,
  default_signer: [
    signer_alg: "RS256",
    key_pem: """
    -----BEGIN RSA PRIVATE KEY-----
    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
    -----END RSA PRIVATE KEY-----
    """
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  discovery: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
