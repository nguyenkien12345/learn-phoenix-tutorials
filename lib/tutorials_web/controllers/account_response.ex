defmodule TutorialsWeb.AccountResponse do

  def success_response(data), do: %{data: data, status: true}

  def error_response(error), do: %{error: error, status: false}

end
