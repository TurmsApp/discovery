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
