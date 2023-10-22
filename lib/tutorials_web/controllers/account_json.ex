defmodule TutorialsWeb.AccountJSON do
  alias Tutorials.Accounts.Account
  alias TutorialsWeb.CustomResponse

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    data = %{data: for(account <- accounts, do: data(account))}
    CustomResponse.success_response(data)
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    data = %{data: data(account)}
    CustomResponse.success_response(data)
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
    }
  end

  defp data_full_account(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
      user: %{
        id: account.user.id,
        full_name: account.user.full_name,
        biography: account.user.biography,
        gender: account.user.gender
      }
    }
  end

  def show_account_token(%{token: token}) do
    data = %{token: token}
    CustomResponse.success_response(data)
  end

  def show_full_account(%{account: account}) do
    data = %{data: data_full_account(account)}
    CustomResponse.success_response(data)
  end

end
