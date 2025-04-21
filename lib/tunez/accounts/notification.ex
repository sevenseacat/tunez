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
    create :create do
      accept [:user_id, :album_id]
    end
  end

  policies do
    policy action(:create) do
      forbid_if always()
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
