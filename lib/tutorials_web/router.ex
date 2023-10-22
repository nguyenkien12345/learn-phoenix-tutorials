defmodule TutorialsWeb.Router do
  use TutorialsWeb, :router
  use Plug.ErrorHandler
  alias Tutorials.Utils.{Error}

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
  end

  # def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
  #   conn |> json(%{errors: message, status: false, timestamp: DateTime.utc_now()}) |> halt()
  # end

  # def handle_errors(conn, %{reason: %{message: message}}) do
  #   conn |> json(%{errors: message, status: false, timestamp: DateTime.utc_now()}) |> halt()
  # end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    IO.puts("handle_errors")
    IO.inspect(reason)
    with {status, error} when not is_nil(error) <- Error.transform(reason) do
      conn
      |> put_status(status)
      |> json(%{errors: error, status: false, timestamp: DateTime.utc_now()}) |> halt()
    else
      _ ->
      conn
      |> put_status(:internal_server_error)
      |> json(%{errors: [%Error{code: Error.c_INTERNAL_SERVER_ERROR()}], status: false, timestamp: DateTime.utc_now()}) |> halt()
    end
  end
end
