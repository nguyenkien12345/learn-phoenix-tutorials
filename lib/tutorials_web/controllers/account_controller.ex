defmodule TutorialsWeb.AccountController do
  use TutorialsWeb, :controller

  alias TutorialsWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias Tutorials.{Accounts.Accounts, Accounts.Account, Users.Users, Users.User}
  alias Tutorials.Utils.{Constants, Error, Validator}

  import TutorialsWeb.Auth.AuthorizedPlugAccount

  plug :is_authorized when action in [:show, :show_full_account, :update, :delete]

  action_fallback TutorialsWeb.FallbackController

  defp authorize_account(conn, email, hash_password) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:show_account_token, %{token: token})
      {:error, :unauthorized} ->
          raise Error, code: Error.c_UNAUTHENTICATED()
    end
  end

  def index(conn, params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def current_account(conn, %{}) do
    conn
    |> put_status(:ok)
    |> render(conn, :show_full_account, account: conn.assigns.account)
  end

  @api_param_schema_sign_up %{
    email: [
      type: :string,
      format: Constants.c_EMAIL_FORMAT(),
      required: true
    ],
    hash_password: [
      type: :string,
      required: true,
      length: [{:min, 6}, {:max, 255}],
    ]
  }
  def create(conn, params) do
    params =
    @api_param_schema_sign_up
    |> Validator.parse(params)
    |> Validator.get_validated_changes!()

    %{email: email, hash_password: hash_password} = params

    with {:ok, %Account{} = account} <- Accounts.create_account(params),
         {:ok, %User{} = _user} <- Users.create_user(account, params) do
        authorize_account(conn, email, hash_password)
    end
  end

  @api_param_schema_sign_in %{
    email: [
      type: :string,
      required: true
    ],
    hash_password: [
      type: :string,
      required: true
    ]
  }
  def sign_in(conn, params) do
    %{email: email, hash_password: hash_password} =
    @api_param_schema_sign_in
    |> Validator.parse(params)
    |> Validator.get_validated_changes!()

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
        raise Error, code: Error.c_UNAUTHENTICATED()
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
