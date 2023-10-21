defmodule TutorialsWeb.Auth.AuthorizedPlugAccount do
  alias TutorialsWeb.Auth.ErrorResponse

  # conn contains parameters passed via URL or form in the HTTP request.
  # conn.assigns contains the values that you want to attach to the connection so that they can be used in other parts of the application.
  def is_authorized(conn, _opts) do
    case conn.params do
      %{"account" => params} ->
        if conn.assigns.account.id == params["id"] do
          conn
        else
          raise ErrorResponse.Forbidden, message: "You do not have permission to access."
        end
      %{"id" => id} ->
        if conn.assigns.account.id == id do
          conn
        else
          raise ErrorResponse.Forbidden, message: "You do not have permission to access."
        end
    end
  end

end
