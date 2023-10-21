defmodule TutorialsWeb.AccountController do
  use TutorialsWeb, :controller

  alias TutorialsWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias Tutorials.{Accounts.Accounts, Accounts.Account, Users.Users, Users.User}

  import TutorialsWeb.Auth.AuthorizedPlugAccount

  plug :is_authorized when action in [:show, :show_full_account, :update, :delete]

  action_fallback TutorialsWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  defp authorize_account(conn, email, hash_password) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:show_account_token, %{token: token})
      {:error, :unauthorized} ->
          raise ErrorResponse.Unauthorized, message: "Email or password incorrect."
    end
  end

  def current_account(conn, %{}) do
    conn
    |> put_status(:ok)
    |> render(conn, :show_full_account, account: conn.assigns.account)
  end

  # account là request được phía fe truyền lên
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
        authorize_account(conn, account.email, account_params["hash_password"])
    end
  end

  # email và hash_password là request được phía fe truyền lên
  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    authorize_account(conn, email, hash_password)
  end

  def sign_out(conn, %{}) do
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)
    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render(:show_account_token, %{token: nil})
  end

  def refresh_token(conn, %{}) do
    token = Guardian.Plug.current_token(conn)
    {:ok, account, new_token} = Guardian.authenticate(token)
    conn
    |> Plug.Conn.put_session(:account_id, account.id)
    |> put_status(:ok)
    |> render(:show_account_token, %{token: new_token})
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def show_full_account(conn, %{"id" => id}) do
    account = Accounts.get_full_account(id)
    render(conn, :show_full_account, account: account)
  end

  def update(conn, %{"account" => account_params}) do
    case Guardian.validate_password(account_params["current_hash_password"], conn.assigns.account.hash_password) do
      true ->
          {:ok, account} = Accounts.update_account(conn.assigns.account, account_params)
          render(conn, :show, account: account)
      false ->
        raise ErrorResponse.Unauthorized, message: "Password incorrect"
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
