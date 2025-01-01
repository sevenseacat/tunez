defmodule Tunez.Music.Album do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "albums"
    repo Tunez.Repo

    references do
      reference :artist, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end

    update :update do
      accept [:name, :year_released, :cover_image_url]
    end
  end

  preparations do
    prepare build(sort: [year_released: :desc])
  end

  validations do
    validate numericality(:year_released,
               greater_than: 1950,
               less_than_or_equal_to: &__MODULE__.next_year/0
             ),
             where: [present(:year_released)],
             message: "must be between 1950 and next year"

    validate match(
               :cover_image_url,
               ~r/(^https:\/\/|\/images\/).+(\.png|\.jpg)$/
             ),
             message: "must start with https:// or /images/"
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :year_released, :integer do
      allow_nil? false
    end

    attribute :cover_image_url, :string

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :artist, Tunez.Music.Artist do
      allow_nil? false
    end
  end

  identities do
    identity :unique_album_names_per_artist, [:name, :artist_id],
      message: "already exists for this artist"
  end

  def next_year, do: Date.utc_today().year + 1
end
