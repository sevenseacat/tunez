defmodule Tunez.Music.ArtistFollower do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "artist_followers"
    repo Tunez.Repo

    references do
      reference :artist, on_delete: :delete, index?: true
      reference :follower, on_delete: :delete
    end
  end

  actions do
    defaults [:read]
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end

  relationships do
    belongs_to :artist, Tunez.Music.Artist do
      primary_key? true
      allow_nil? false
    end

    belongs_to :follower, Tunez.Accounts.User do
      primary_key? true
      allow_nil? false
    end
  end
end
