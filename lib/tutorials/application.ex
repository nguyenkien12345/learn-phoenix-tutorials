defmodule Tutorials.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TutorialsWeb.Telemetry,
      Tutorials.Repo,
      {DNSCluster, query: Application.get_env(:tutorials, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tutorials.PubSub},
      # Start a worker by calling: Tutorials.Worker.start_link(arg)
      # {Tutorials.Worker, arg},
      # Start to serve requests, typically the last entry
      TutorialsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tutorials.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TutorialsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
