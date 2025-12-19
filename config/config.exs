# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :discovery,
  ecto_repos: [Turms.Repo],
  generators: [timestamp_type: :utc_datetime]

host = System.get_env("PHX_HOST") || "localhost"
port = String.to_integer(System.get_env("PORT") || "4000")

# Configures the endpoint
config :discovery, TurmsWeb.Endpoint,
  url: [host: host],
  server: true,
  http: [
    # Enable IPv6 and bind on all interfaces.
    # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
    # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
    # for details about using IPv6 vs IPv4 and loopback vs public addresses.
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    port: port
  ],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TurmsWeb.ErrorHTML, json: TurmsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Turms.PubSub,
  live_view: [signing_salt: "4NVHfst6"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  discovery: [
    args:
      ~w(--bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.10",
  discovery: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
