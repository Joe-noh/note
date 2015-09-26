defmodule Note.PageController do
  use Note.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
