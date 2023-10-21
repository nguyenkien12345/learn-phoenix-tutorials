defmodule TutorialsWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :tutorials,      # part of Guardian, to build an authentication and authorization pipeline.
  module: TutorialsWeb.Auth.Guardian,                   # Used for authentication and authorization
  error_handler: TutorialsWeb.Auth.GuardianErrorHandler # Handles errors during authentication.

  plug Guardian.Plug.VerifySession                      # Check the user's login session and ensure that the login session is valid.
  plug Guardian.Plug.VerifyHeader                       # Check the header in the HTTP request to determine whether the login session is valid or not.
  plug Guardian.Plug.EnsureAuthenticated                # Ensure that users are logged in before allowing access to secure resources.
  plug Guardian.Plug.LoadResource                       # Identify and load resources associated with the logged in user.
end
