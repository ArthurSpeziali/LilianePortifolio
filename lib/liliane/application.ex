defmodule Liliane.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LilianeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:liliane, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Liliane.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Liliane.Finch},
      # Start a worker by calling: Liliane.Worker.start_link(arg)
      # {Liliane.Worker, arg},
      # Start to serve requests, typically the last entry
      LilianeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Liliane.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LilianeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
