defmodule TutorialsWeb.AccountJSON do
  alias Tutorials.Accounts.Account
  alias TutorialsWeb.AccountResponse

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    data = %{data: for(account <- accounts, do: data(account))}
    AccountResponse.success_response(data)
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    data = %{data: data(account)}
    AccountResponse.success_response(data)
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
    }
  end

  def show_account_token(%{account: account, token: token}) do
    data = %{id: account.id, email: account.email, token: token}
    AccountResponse.success_response(data)
  end

end
