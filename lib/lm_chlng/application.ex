defmodule LmChlng.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LmChlngWeb.Telemetry,
      # Start the Ecto repository
      LmChlng.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LmChlng.PubSub},
      # Start Finch
      {Finch, name: LmChlng.Finch},
      LmChlng.Vault,
      # Start the Endpoint (http/https)
      LmChlngWeb.Endpoint,
      {Oban, Application.fetch_env!(:lm_chlng, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LmChlng.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LmChlngWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
