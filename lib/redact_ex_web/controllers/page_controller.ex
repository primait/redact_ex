defmodule RedactExWeb.PageController do
  use RedactExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def check(conn, _params) do
    send_resp(conn, 200, "")
  end
end
