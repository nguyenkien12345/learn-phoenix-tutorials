defmodule TutorialsWeb.DefaultController do
  # use => is a macro keyword
  # :controller => will inherit the features and settings of a controller in the Phoenix framework.
  use TutorialsWeb, :controller

  def index(conn, _params) do
    # conn => represents the HTTP connection between server and client. In Phoenix, conn contains information about
    # the HTTP request and will be used to send the response back to the client.

    # text conn => uses the text function to send a text HTTP response to the client via the conn connection
    text conn, "The Tutorials is running at environment: #{Mix.env()}"
  end
end
