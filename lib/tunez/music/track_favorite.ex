defmodule Tunez.Music.TrackFavorite do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshGraphql.Resource]

  require Ash.Query

  graphql do
    type :track_favorite
  end

  postgres do
    table "track_favorites"
    repo Tunez.Repo

    references do
      reference :track, on_delete: :delete, index?: true
      reference :user, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:track_id]

      change relate_actor(:user, allow_nil?: false)
    end

    action :unfavorite_gracefully do
      argument :track_id, :uuid do
        allow_nil? false
      end

      run fn changeset, context ->
        __MODULE__
        |> Ash.Query.filter(track_id == ^changeset.arguments.track_id)
        |> Ash.bulk_destroy!(:destroy, %{}, Ash.Context.to_opts(context))

        :ok
      end
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:destroy) do
      authorize_if actor_present()
    end

    policy action_type(:action) do
      authorize_if actor_present()
    end
  end

  relationships do
    belongs_to :track, Tunez.Music.Track do
      primary_key? true
      allow_nil? false
    end

    belongs_to :user, Tunez.Accounts.User do
      primary_key? true
      allow_nil? false
    end
  end
end
