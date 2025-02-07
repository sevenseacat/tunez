defmodule Tunez.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Tunez.Accounts.User, _opts) do
    Application.fetch_env(:tunez, :token_signing_secret)
  end
end
