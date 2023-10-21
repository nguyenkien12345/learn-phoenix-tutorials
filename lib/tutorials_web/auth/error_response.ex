defmodule TutorialsWeb.Auth.ErrorResponse.BadRequest do
  defexception [message: "Bad Request", plug_status: 400]
end

defmodule TutorialsWeb.Auth.ErrorResponse.Unauthorized do
  defexception [message: "Unauthorized", plug_status: 401]
end

defmodule TutorialsWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "Forbidden", plug_status: 403]
end

defmodule TutorialsWeb.Auth.ErrorResponse.NotFound do
  defexception [message: "Not Found", plug_status: 404]
end
