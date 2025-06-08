defmodule Tunez.Music.Track do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshGraphql.Resource, AshJsonApi.Resource]

  graphql do
    type :track

    derive_filter? false
    derive_sort? false
  end

  json_api do
    type "track"
    default_fields [:number, :name, :duration]
  end

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
      accept [:order, :name, :album_id]
      argument :duration, :string, allow_nil?: false
      change Tunez.Music.Changes.MinutesToSeconds, only_when_valid?: true
    end

    update :update do
      primary? true
      accept [:order, :name]
      require_atomic? false
      argument :duration, :string, allow_nil?: false
      change Tunez.Music.Changes.MinutesToSeconds, only_when_valid?: true
    end
  end

  policies do
    policy always() do
      authorize_if accessing_from(Tunez.Music.Album, :tracks)
      authorize_if action_type(:read)
    end
  end

  preparations do
    prepare build(load: [:number, :duration])
  end

  attributes do
    uuid_primary_key :id

    attribute :order, :integer do
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? false
      public? true
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

    has_many :track_favorites, Tunez.Music.TrackFavorite

    many_to_many :favorited_by_users, Tunez.Accounts.User do
      join_relationship :track_favorites
      source_attribute_on_join_resource :track_id
      destination_attribute_on_join_resource :user_id
    end
  end

  calculations do
    calculate :number, :integer, expr(order + 1) do
      public? true
    end

    calculate :duration, :string, Tunez.Music.Calculations.SecondsToMinutes do
      public? true
    end

    calculate :favorited_by_me,
              :boolean,
              expr(exists(track_favorites, user_id == ^actor(:id))) do
      public? true
    end
  end
end
