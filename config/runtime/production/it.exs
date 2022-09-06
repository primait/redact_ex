import Config

port = String.to_integer(System.get_env("PORT") || "4000")

config :redact_ex, RedactExWeb.Endpoint,
  server: true,
  url: [scheme: "https", host: "redact_ex.prima.it", port: 443],
  http: [
    # Enable IPv6 and bind on all interfaces.
    # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
    # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
    # for details about using IPv6 vs IPv4 and loopback vs public addresses.
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    port: port
  ],
  secret_key_base: System.get_env("secret_key_base_it_production")

config :redact_ex, RedactEx.Repo,
  username: "redact_ex",
  database: "redact_ex",
  hostname: "pgsql-production.prima.prod",
  password: System.get_env("redact_ex_production_it_db_pgsql"),
  pool_size: 10

config :prima_auth0_ex,
  auth0_base_url: "https://prima-it-production.eu.auth0.com"

config :prima_auth0_ex, :server,
  audience: "redact_ex",
  issuer: "https://prima-it-production.eu.auth0.com/"
