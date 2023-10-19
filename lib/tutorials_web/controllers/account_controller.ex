defmodule TutorialsWeb.AccountController do
  use TutorialsWeb, :controller

  alias TutorialsWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias Tutorials.{Accounts.Accounts, Accounts.Account, Users.Users, Users.User}

  plug :is_authorized_account when action in [:update]

  action_fallback TutorialsWeb.FallbackController

  # account là request được phía fe truyền lên
  defp is_authorized_account(conn, _opts) do
    %{ params: %{"account" => params} } = conn
    account = Accounts.get_account!(params["id"])
    if conn.assigns.account.id == account.id do
      conn
    else
      raise ErrorResponse.Forbidden, message: "You do not have permission to access."
    end
  end


  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  # account là request được phía fe truyền lên
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render(:show_account_token, %{account: account, token: token})
    end
  end

  # email và hash_password là request được phía fe truyền lên
  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:show_account_token, %{account: account, token: token})
      {:error, :unauthorized} ->
          raise ErrorResponse.Unauthorized, message: "Email or password incorrect."
    end
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)
    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render(:show_account_token, %{account: account, token: nil})
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)

    # Use session
    # render(conn, :show, account: conn.assigns.account)
  end

  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
