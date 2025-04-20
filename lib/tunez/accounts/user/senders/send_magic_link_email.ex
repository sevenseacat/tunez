defmodule Tunez.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use TunezWeb, :verified_routes

  import Swoosh.Email
  alias Tunez.Mailer

  @impl true
  def send(user_or_email, token, _) do
    # if you get a user, its for a user that already exists.
    # if you get an email, then the user does not yet exist.

    email =
      case user_or_email do
        %{email: email} -> email
        email -> email
      end

    new()
    # TODO: Replace with your email
    |> from({"noreply", "noreply@example.com"})
    |> to(to_string(email))
    |> subject("Your login link")
    |> html_body(body(token: token, email: email))
    |> Mailer.deliver!()
  end

  defp body(params) do
    url = url(~p"/auth/user/magic_link/?token=#{params[:token]}")

    """
    <p>Hello, #{params[:email]}! Click this link to sign in:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
