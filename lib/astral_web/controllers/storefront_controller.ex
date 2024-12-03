defmodule AstralWeb.StorefrontController do
  use AstralWeb, :controller

  def keychain(conn, _params) do
    case HTTPoison.get("https://api.nitestats.com/v1/epic/keychain") do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        conn
        |> put_status(200)
        |> json(Jason.decode!(body))

      {:error, %HTTPoison.Error{reason: reason}} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to fetch data", reason: reason})
    end
  end
end
