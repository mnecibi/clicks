defmodule Clicks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      ClicksWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:clicks, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Clicks.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Clicks.Finch},
      # Start a worker by calling: Clicks.Worker.start_link(arg)
      # {Clicks.Worker, arg},
      # Start to serve requests, typically the last entry
      ClicksWeb.Presence,
      ClicksWeb.Endpoint,
      {Cluster.Supervisor, [topologies, [name: Clicks.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clicks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClicksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
