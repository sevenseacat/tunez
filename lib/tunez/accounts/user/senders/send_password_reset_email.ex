defmodule Tunez.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """

  use AshAuthentication.Sender
  use TunezWeb, :verified_routes

  @impl true
  def send(user, token, _) do
    Tunez.Emails.deliver_password_reset_email(
      user,
      url(~p"/password-reset/#{token}")
    )
  end
end
