defmodule Tunez.Music do
  use Ash.Domain,
    otp_app: :tunez

  resources do
    resource Tunez.Music.Artist
  end
end
