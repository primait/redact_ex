defmodule RedactExWeb.Graphql.Middleware.RequirePermission do
  @behaviour Absinthe.Middleware

  def call(resolution, permission) do
    if permission in resolution.context[:permissions] do
      resolution
    else
      Absinthe.Resolution.put_result(resolution, {:error, "unauthorized"})
    end
  end
end
