defmodule Tunez.Music.Track do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "tracks"
    repo Tunez.Repo

    references do
      reference :album, index?: true, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:order, :name, :duration_seconds, :album_id]
    end

    update :update do
      primary? true
      accept [:order, :name, :duration_seconds]
    end
  end

  policies do
    policy always() do
      authorize_if accessing_from(Tunez.Music.Album, :tracks)
      authorize_if action_type(:read)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :order, :integer do
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? false
    end

    attribute :duration_seconds, :integer do
      allow_nil? false
      constraints min: 1
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :album, Tunez.Music.Album do
      allow_nil? false
    end
  end
end
