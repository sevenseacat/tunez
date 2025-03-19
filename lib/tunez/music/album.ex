defmodule Tunez.Music.Album do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshJsonApi.Resource, AshAi],
    authorizers: [Ash.Policy.Authorizer]

  graphql do
    type :album
  end

  json_api do
    type "album"
  end

  postgres do
    table "albums"
    repo Tunez.Repo

    references do
      reference :artist, on_delete: :delete
    end
  end

  vectorize do
    full_text do
      text fn record ->
        """
        Name: #{record.name}
        Year Released: #{record.year_released}
        """
      end
    end

    attributes name: :vectorized_name

    embedding_model(Tunez.OpenAIEmbeddingModel)
  end

  actions do
    defaults [:read, :destroy]

    read :get do
      get_by [:id]
    end

    create :create do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end

    update :update do
      accept [:name, :year_released, :cover_image_url]
    end
  end

  policies do
    bypass AshAi.Checks.ActorIsAshAi do
      authorize_if always()
    end

    bypass actor_attribute_equals(:role, :admin) do
      authorize_if always()
    end

    policy action_type(:read) do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if actor_attribute_equals(:role, :editor)
    end

    policy action_type([:update, :destroy]) do
      authorize_if expr(^actor(:role) == :editor and created_by_id == ^actor(:id))
    end
  end

  preparations do
    prepare build(sort: [year_released: :desc])
  end

  changes do
    change relate_actor(:created_by, allow_nil?: true),
      on: [:create],
      where: [negate({AshAi.Validations.ActorIsAshAi, []})]

    change relate_actor(:updated_by, allow_nil?: true),
      on: [:create],
      where: [negate({AshAi.Validations.ActorIsAshAi, []})]

    change relate_actor(:updated_by, allow_nil?: false),
      on: [:update],
      where: [negate({AshAi.Validations.ActorIsAshAi, []})]
  end

  validations do
    validate numericality(:year_released,
               greater_than: 1950,
               less_than_or_equal_to: &__MODULE__.next_year/0
             ),
             where: [present(:year_released)],
             message: "must be between 1950 and next year"

    validate match(:cover_image_url, ~r"(^https://|/images/).+(\.png|\.jpg)$"),
      where: [changing(:cover_image_url)],
      message: "must start with https:// or /images/"
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :year_released, :integer do
      allow_nil? false
      public? true
    end

    attribute :description, :string

    attribute :cover_image_url, :string do
      public? true
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  def next_year, do: Date.utc_today().year + 1

  relationships do
    belongs_to :artist, Tunez.Music.Artist do
      public? true
      allow_nil? false
    end

    belongs_to :created_by, Tunez.Accounts.User
    belongs_to :updated_by, Tunez.Accounts.User
  end

  identities do
    identity :unique_album_names_per_artist, [:name, :artist_id],
      message: "already exists for this artist"
  end
end
