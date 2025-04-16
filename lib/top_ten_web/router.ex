defmodule TopTenWeb.Router do
  use TopTenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TopTenWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TopTenWeb.Plugs.UserIdentity
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TopTenWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/lists/new", ListLive.New, :new
    live "/lists/:slug", ListLive.View, :view
    live "/lists/:slug/edit", ListLive.Edit, :edit
    
    resources "/lists", TopTenListController do
      resources "/items", ItemController, except: [:index, :show]
      end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TopTenWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:top_ten, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TopTenWeb.Telemetry
    end
  end
end
