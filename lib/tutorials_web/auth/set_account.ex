defmodule TutorialsWeb.Auth.SetAccount do

  import Plug.Conn
  alias TutorialsWeb.Auth.ErrorResponse
  alias Tutorials.Accounts.Accounts
  alias Tutorials.Utils.{Error}

  # The function init/1 does not do any work and returns :ok.
  # This is a mandatory requirement if this module is used in a Guardian pipeline
  def init(_options) do
  end

  def call(conn, _options) do
    if conn.assigns[:account] do
      conn
    else
      account_id = get_session(conn, :account_id)

      if account_id == nil do
        raise Error, code: Error.c_UNAUTHENTICATED()
      end

      account = Accounts.get_full_account(account_id)
      cond do
        account -> assign(conn, :account, account)
        true ->  assign(conn, :account, nil)
      end
    end
  end

end
