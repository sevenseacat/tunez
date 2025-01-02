defmodule Tunez.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TunezWeb.Telemetry,
      Tunez.Repo,
      {DNSCluster, query: Application.get_env(:tunez, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tunez.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tunez.Finch},
      # Start a worker by calling: Tunez.Worker.start_link(arg)
      # {Tunez.Worker, arg},
      # Start to serve requests, typically the last entry
      TunezWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :tunez]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tunez.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TunezWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
