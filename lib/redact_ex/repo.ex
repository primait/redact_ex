defmodule RedactEx.Repo do
  use Ecto.Repo,
    otp_app: :redact_ex,
    adapter: Ecto.Adapters.Postgres
end
