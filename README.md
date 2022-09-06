[![CI status](https://drone-1.prima.it/api/badges/primait/redact_ex/status.svg?branch=master)](https://drone-1.prima.it/primait/redact_ex) [![Test Coverage](https://github.com/primait/redact_ex/workflows/Test%20Coverage/badge.svg)](https://github.com/primait/redact_ex/actions?query=workflow%3A%22Test+Coverage%22)

# redact_ex

Utilities to redact sensitive data in Elixir projects

## Run locally

### Setup Auth0

To access some endpoints, queries and/or mutations, requests will need to be authenticated via a JWT.

In staging and production-like environment this will be handled via Auth0.
However, to simplify local development, on the local dev environment JWTs are accepted even when their signature is not valid (only a warning will be logged on invalid JWT signature).
This means that it is possible to use locally forged JWT tokens for local instances of this application.

To forge a new token for local development open a `iex` shell with `iex -S mix` and run

```elixir
PrimaAuth0Ex.LocalToken.forge("redact_ex", %{permissions: ["some:permission"]})
```

### Run

The recommended way to work locally is to spawn a shell inside a Docker container with the following command:

```bash
docker-compose run --service-ports --rm web bash
```

Then, to install dependencies and setup the database run:

```bash
mix deps.get
mix ecto.setup
```

Then, run the application as follows:

```bash
mix phx.server
```

The GraphQL endpoint will be available at http://localhost:4000/graphql.

Tests can be run with:

```bash
mix test
```

## API examples

You can find an Insomnia collection with API usage examples in the `examples` folder.
