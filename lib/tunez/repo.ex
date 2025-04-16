defmodule Tunez.Repo do
  use AshPostgres.Repo,
    otp_app: :tunez

  @impl true
  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    ["ash-functions", "pg_trgm"]
  end

  # Don't open unnecessary transactions
  # will default to `false` in 4.0
  @impl true
  def prefer_transaction? do
    false
  end

  @impl true
  def min_pg_version do
    %Version{major: 15, minor: 4, patch: 0}
  end
end
