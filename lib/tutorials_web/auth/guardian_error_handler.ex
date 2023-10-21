defmodule TutorialsWeb.Auth.GuardianErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _options) do
    error = Jason.encode!(%{error: to_string(type), status: false, timestamp: DateTime.utc_now()})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, error)
  end
end
