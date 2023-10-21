defmodule TutorialsWeb.AccountResponse do

  # def success_response(data), do: %{data: data, status: true, timestamp: DateTime.utc_now()}
  # def error_response(error), do: %{error: error, status: false, timestamp: DateTime.utc_now()}

  def success_response(data) do
    Map.merge(data, %{status: true, timestamp: DateTime.utc_now()})
  end

  def error_response(error) do
    Map.merge(error, %{status: false, timestamp: DateTime.utc_now()})
  end

end
