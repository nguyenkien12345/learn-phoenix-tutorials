defmodule TutorialsWeb.Router do
  use TutorialsWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  # pipeline (process stream)

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug TutorialsWeb.Auth.Pipeline
    plug TutorialsWeb.Auth.SetAccount
  end

  # Unprotected Endpoint
  scope "/api", TutorialsWeb do
    pipe_through :api

    get "/", DefaultController, :index

    post "/accounts/register", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  # Protected Endpoint
  scope "/api", TutorialsWeb do
    pipe_through [:api, :auth]

    get "/accounts", AccountController, :index
    put "/accounts/update", AccountController, :update
    get "/accounts/refresh_token", AccountController, :refresh_token
    get "/accounts/sign_out", AccountController, :sign_out
    get "/accounts/user/:id", AccountController, :show_full_account
    get "/accounts/:id", AccountController, :show

    # get "/users", UserController, :index
    # put "/users/update", UserController, :update
    # get "/users/:id", UserController, :show
  end
end
