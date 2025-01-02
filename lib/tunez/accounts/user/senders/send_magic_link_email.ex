defmodule Tunez.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use TunezWeb, :verified_routes

  @impl true
  def send(user_or_email, token, _) do
    email =
      case user_or_email do
        %{email: email} -> email
        email -> email
      end

    Tunez.Emails.deliver_magic_link_email(
      email,
      url(~p"/auth/user/magic_link/?token=#{token}")
    )
  end
end
