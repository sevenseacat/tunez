defmodule Tunez.Accounts.Notification do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "notifications"
    repo Tunez.Repo

    references do
      reference :user, index?: true, on_delete: :delete
      reference :album, on_delete: :delete
    end
  end

  actions do
    defaults [:destroy]

    read :for_user do
      prepare build(load: [album: [:artist]], sort: [inserted_at: :desc])
      filter expr(user_id == ^actor(:id))
    end

    create :create do
      accept [:user_id, :album_id]
    end
  end

  policies do
    policy action(:for_user) do
      authorize_if actor_present()
    end

    policy action(:create) do
      forbid_if always()
    end

    policy action(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :user, Tunez.Accounts.User do
      allow_nil? false
    end

    belongs_to :album, Tunez.Music.Album do
      allow_nil? false
    end
  end
end
