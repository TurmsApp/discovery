defmodule Turms.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TurmsWeb.Telemetry,
      Turms.Repo,
      {DNSCluster, query: Application.get_env(:discovery, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Turms.PubSub},
      # Start to serve requests, typically the last entry.
      TurmsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Turms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TurmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
