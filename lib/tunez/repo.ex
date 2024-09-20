defmodule Tunez.Repo do
  use Ecto.Repo,
    otp_app: :tunez,
    adapter: Ecto.Adapters.Postgres
end
