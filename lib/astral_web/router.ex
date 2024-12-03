defmodule AstralWeb.Router do
  use AstralWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AstralWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AstralWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

scope "/fortnite/api", AstralWeb do
  pipe_through :api


  post "/game/v2/tryPlayOnPlatform/account/:accountId", DataController, :tryplayonplatform
  get "/versioncheck", DataController, :versioncheck
  get "/v2/versioncheck", DataController, :versioncheck
  get "/v2/versioncheck/*path", DataController, :versioncheck
  get "/cloudstorage/user/*path", DataController, :access
  post "/game/v2/grant_access/*path", DataController, :access
  put "/cloudstorage/user/:accountId/ClientSettings.Sav", DataController, :access
  get "/game/v2/twitch/*path", DataController, :access
  get "/calendar/v1/timeline", TimelineController, :timeline
end

scope "/fortnite/api/storefront/v2", AstralWeb do
  pipe_through :api

  get "/keychain", StorefrontController, :keychain
end

scope "/datarouter/api/v1/public", AstralWeb do
    pipe_through :api

    post "/data", DataController, :datarouter
 end

  scope "/lightswitch/api", AstralWeb do
    pipe_through :api

    get "/service/bulk/status", DataController, :lightswitch
 end

  scope "/socialban/api", AstralWeb do
    pipe_through :api

    get "/public/v1/:accountId/ban", DataController, :socialban
  end


  scope "/account/api", AstralWeb do
    pipe_through :api

    
    delete "/oauth/sessions", DataController, :enabled
    delete "/oauth/sessions/*path", DataController, :enabled
    get "/oauth/verify", DataController, :enabled
  end

scope "/waitingroom/api", AstralWeb do
  get "/waitingroom", DataController, :waitingroom
end




































  # Other scopes may use custom stacks.
  # scope "/api", AstralWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:astral, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AstralWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
