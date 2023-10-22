defmodule TutorialsWeb.Auth.AuthorizedPlugAccount do
  alias TutorialsWeb.Auth.ErrorResponse
  alias Tutorials.Utils.{Error}

  # conn contains parameters passed via URL or form in the HTTP request.
  # conn.assigns contains the values that you want to attach to the connection so that they can be used in other parts of the application.
  def is_authorized(conn, _opts) do
    case conn.params do
      %{"account" => params} ->
        if conn.assigns.account.id == params["id"] do
          conn
        else
          raise Error, code: Error.c_FORBIDDEN()
        end
      %{"id" => id} ->
        if conn.assigns.account.id == id do
          conn
        else
          raise Error, code: Error.c_FORBIDDEN()
        end
    end
  end

end
