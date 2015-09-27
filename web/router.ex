defmodule Note.Router do
  use Note.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource, key: :current_user
    plug Guardian.Plug.EnsureAuthenticated,
      on_failure: {Note.SessionController, :unauthenticated}
  end

  pipeline :api_without_auth do
    plug :accepts, ["json"]
  end

  scope "/", Note do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
  end

  scope "/api", Note do
    pipe_through :api

    resources "/users", UserController, only: [:show, :update, :delete]
  end

  scope "/api", Note do
    pipe_through :api_without_auth

    resources "/users", UserController, only: [:create]
    post   "/login",  SessionController, :create
  end
end
