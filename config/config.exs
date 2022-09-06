# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :redact_ex,
  ecto_repos: [RedactEx.Repo]

# Configures the endpoint
config :redact_ex, RedactExWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RedactExWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RedactEx.PubSub,
  live_view: [signing_salt: "SRVeRpow"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :redact_ex, RedactEx.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :prima_auth0_ex, :server,
  audience: "redact_ex",
  issuer: "my-auth0-issuer"

config :prima_auth0_ex,
  auth0_base_url: "https://prima-assicurazioni.eu.auth0.com"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
