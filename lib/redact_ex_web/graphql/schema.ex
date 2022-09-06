defmodule RedactExWeb.Graphql.Schema do
  use Absinthe.Schema
  alias RedactExWeb.Graphql.Middleware.RequirePermission

  query do
    @desc "Greet"
    field :greet, :string do
      middleware RequirePermission, "read:greet"
      resolve &hello_world/2
    end
  end

  defp hello_world(_, _), do: {:ok, "Hello World!"}
end
