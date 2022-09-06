defmodule RedactExWeb.Graphql.Context do
  def init(opts), do: opts

  def call(conn, _) do
    permissions =
      case Plug.Conn.get_req_header(conn, "authorization") do
        ["Bearer " <> token] -> PrimaAuth0Ex.Token.peek_permissions(token)
        _ -> []
      end

    Absinthe.Plug.put_options(conn, context: %{permissions: permissions})
  end
end
