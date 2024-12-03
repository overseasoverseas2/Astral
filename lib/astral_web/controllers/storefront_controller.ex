defmodule AstralWeb.StorefrontController do
  use AstralWeb, :controller

  alias Finch.Response

  def keychain(conn, _params) do
  url = "https://api.nitestats.com/v1/epic/keychain"

  case Finch.build(:get, url) |> Finch.request(MyAppFinch) do
    {:ok, %Response{status: 200, body: body}} ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, body)

    {:ok, %Response{status: status, body: body}} ->
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(status, "Failed to fetch keychain: #{body}")

    {:error, %Finch.Error{reason: reason}} ->
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(500, "Error fetching keychain: #{inspect(reason)}")

    unexpected ->
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(500, "Unexpected response: #{inspect(unexpected)}")
  end
end
end