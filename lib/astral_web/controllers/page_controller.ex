defmodule AstralWeb.PageController do
  use AstralWeb, :controller

  def home(conn, _params) do
    conn
    |> put_status(200)
    |> text("Welcome to Astral!")
  end
end
