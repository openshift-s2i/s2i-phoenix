defmodule HelloWorld.PageController do
  use HelloWorld.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
