defmodule AstralWeb.DataController do
  use AstralWeb, :controller

  def datarouter(conn, _params) do
    conn
    |> put_status(204)
    |> json(%{})
  end


   def versioncheck(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{
      type: "NO_UPDATE"
    })
  end

  def lightswitch(conn, _params) do
    conn
    |> put_status(200)
    |> json([
      %{
        serviceInstanceId: "fortnite",
        status: "UP",
        message: "fortnite is up.",
        maintenanceUri: nil,
        overrideCatalogIds: ["a7f138b2e51945ffbfdacc1af0541053"],
        allowedActions: ["PLAY", "DOWNLOAD"],
        banned: false,
        launcherInfoDTO: %{
          appName: "Fortnite",
          catalogItemId: "4fe75bbc5a674f4f9b356b5c90567da5",
          namespace: "fn"
        }
      }
    ])
  end

 def enabled(conn, _params) do
    conn
    |> put_status(200)
    |> json([])
  end

  def socialban(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{
      bans: [],
      warnings: []
    })
  end

 def access(conn, _params) do
    conn
    |> put_status(204)
    |> json(%{})
  end

def waiting_room(conn, _params) do
    conn
    |> put_status(:no_content) 
    |> json([]) 
  end
  
  def tryplayonplatform(conn, _params) do
    conn
    |> put_status(200)
    |> put_resp_header("Content-Type", "text/plain")
    |> text("true")
  end
end