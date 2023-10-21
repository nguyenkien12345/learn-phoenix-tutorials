# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :tutorials,
  ecto_repos: [Tutorials.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :tutorials, TutorialsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: TutorialsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Tutorials.PubSub,
  live_view: [signing_salt: "J8MfBkyX"]

# Configures Elixir's Guardian
config :tutorials, TutorialsWeb.Auth.Guardian,
  issuer: "tutorials",
  secret_key: "T98FTWn7U4YgYqyR0KtQz7ee0CQqz7/S2YwMqKE5I5s3+iZw4jnm2QTdFIx++2Hr"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Elixir's Guardian DB
config :guardian, Guardian.DB,
  repo: Tutorials.Repo,             # Store tokens in the database defined by Tutorials.Repo.
  schema_name: "guardian_tokens",   # The name of the table or collection in the database that Guardian.DB will use to store tokens.
  sweep_interval: 60                # 60 minutes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
