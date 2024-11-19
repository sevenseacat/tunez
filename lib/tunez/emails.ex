defmodule Tunez.Emails do
  @moduledoc """
  Delivers emails.
  """

  import Swoosh.Email

  def deliver_email_confirmation_email(user, url) do
    if !url do
      raise "Cannot deliver confirmation instructions without a url"
    end

    deliver(user.email, "Confirm your email address", """
      <p>Hi #{user.email},</p>

      <p>
        Someone has tried to register a new account using this email address.
        If it was you, then please click the link below to confirm your identity. If you did not initiate this request then please ignore this email.
      </p>

      <p><a href="#{url}">Click here to confirm your account</a></p>
    """)
  end

  def deliver_password_reset_email(user, url) do
    if !url do
      raise "Cannot deliver password reset instructions without a url"
    end

    deliver(user.email, "Reset your password", """
      <p>Hi #{user.email},</p>

      <p>
        Someone has tried to reset the password on your account.
        If it was you, then please click the link below to complete the reset process. If you did not initiate this request then please ignore this email.
      </p>

      <p><a href="#{url}">Click here to reset your password</a></p>
    """)
  end

  def deliver_magic_link_email(email, url) do
    if !url do
      raise "Cannot deliver magic link without a url"
    end

    deliver(email, "Magic link for sign in", """
      <p>Hi #{email},</p>

      <p>
        Someone has tried to sign in using this email address.
        If it was you, then please click the link below to log in. If you did not initiate this request then please ignore this email.
      </p>

      <p><a href="#{url}">Click here to sign in</a></p>
    """)
  end

  defp deliver(to, subject, body) do
    new()
    # TODO: Replace with your email
    |> from({"Tunez", "tunez@sevenseacat.net"})
    |> to(to_string(to))
    |> subject(subject)
    |> put_provider_option(:track_links, "None")
    |> html_body(body)
    |> Tunez.Mailer.deliver!()

    :ok
  end
end
