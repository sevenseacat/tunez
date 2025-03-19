defmodule Tunez.Music.Artist do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshJsonApi.Resource, AshAi],
    authorizers: [Ash.Policy.Authorizer]

  graphql do
    type :artist

    filterable_fields [
      :album_count,
      :cover_image_url,
      :inserted_at,
      :latest_album_year_released,
      :updated_at
    ]
  end

  json_api do
    type "artist"
    includes [:albums]
    derive_filter? false
  end

  postgres do
    table "artists"
    repo Tunez.Repo

    custom_indexes do
      index "name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
  end

  vectorize do
    full_text do
      text fn record ->
        """
        Name: #{record.name}
        Biography: #{record.biography}
        """
      end
    end

    attributes name: :vectorized_name
    embedding_model(Tunez.OpenAIEmbeddingModel)
  end

  resource do
    description "A person or group of people that makes and releases music."
  end

  actions do
    defaults [:create, :read, :destroy]
    default_accept [:name, :biography]

    read :by_id do
      get_by [:id]
    end

    read :search do
      description "List Artists, optionally filtering by name."

      argument :query, :ci_string do
        description "Return only artists with names including the given value."
        constraints allow_empty?: true
        default ""
      end

      filter expr(contains(name, ^arg(:query)))

      pagination offset?: true, default_limit: 12
    end

    update :update do
      require_atomic? false
      accept [:name, :biography]

      change Tunez.Music.Changes.UpdatePreviousNames, where: [changing(:name)]
    end
  end

  policies do
    bypass AshAi.Checks.ActorIsAshAi do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if actor_attribute_equals(:role, :admin)
    end

    policy action_type(:read) do
      authorize_if always()
    end

    policy action(:update) do
      authorize_if actor_attribute_equals(:role, :admin)
      authorize_if actor_attribute_equals(:role, :editor)
    end

    policy action(:destroy) do
      authorize_if actor_attribute_equals(:role, :admin)
    end
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

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :biography, :string do
      public? true
    end

    attribute :previous_names, {:array, :string} do
      default []
      public? true
    end

    create_timestamp :inserted_at, public?: true
    update_timestamp :updated_at, public?: true
  end

  relationships do
    has_many :albums, Tunez.Music.Album do
      public? true
    end

    belongs_to :created_by, Tunez.Accounts.User
    belongs_to :updated_by, Tunez.Accounts.User
  end

  aggregates do
    count :album_count, :albums do
      public? true
    end

    first :latest_album_year_released, :albums, :year_released do
      public? true
    end

    first :cover_image_url, :albums, :cover_image_url
  end
end
