defmodule Tunez.Accounts.Notification do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Accounts, data_layer: AshPostgres.DataLayer

  postgres do
    table "notifications"
    repo Tunez.Repo

    references do
      reference :user, index?: true, on_delete: :delete
      reference :album, on_delete: :delete
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
