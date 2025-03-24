defmodule Tunez.Music do
  use Ash.Domain,
    otp_app: :tunez,
    extensions: [AshGraphql.Domain, AshJsonApi.Domain, AshPhoenix, AshOps, AshAi]

  graphql do
    queries do
      get Tunez.Music.Artist, :get_artist_by_id, :read
      list Tunez.Music.Artist, :search_artists, :search
    end

    mutations do
      create Tunez.Music.Artist, :create_artist, :create
      update Tunez.Music.Artist, :update_artist, :update
      destroy Tunez.Music.Artist, :destroy_artist, :destroy
      create Tunez.Music.Album, :create_album, :create
      update Tunez.Music.Album, :update_album, :update
      destroy Tunez.Music.Album, :destroy_album, :destroy
    end
  end

  json_api do
    routes do
      base_route "/artists", Tunez.Music.Artist do
        get :read
        index :search
        post :create
        patch :update
        delete :destroy
        related :albums, :read, primary?: true
      end

      base_route "/albums", Tunez.Music.Album do
        post :create
        patch :update
        delete :destroy
      end
    end
  end

  mix_tasks do
    create Tunez.Music.Album, :create_album, :create
    list Tunez.Music.Album, :list_albums, :read
    get Tunez.Music.Album, :get_album, :read
  end

  tools do
    tool :create_artist, Tunez.Music.Artist, :create
    tool :update_artist, Tunez.Music.Artist, :update
    tool :destroy_artist, Tunez.Music.Artist, :destroy
    tool :search_artists, Tunez.Music.Artist, :search
    tool :list_artists, Tunez.Music.Artist, :read
    tool :vector_search_artists, Tunez.Music.Artist, :vector_search

    tool :create_album, Tunez.Music.Album, :create
    tool :update_album, Tunez.Music.Album, :update
    tool :destroy_album, Tunez.Music.Album, :destroy
    tool :search_albums, Tunez.Music.Album, :search
    tool :list_albums, Tunez.Music.Album, :read
    tool :vector_search_albums, Tunez.Music.Album, :vector_search

    tool :analyze_sentiment, Tunez.Music.Actions, :analyze_sentiment
    tool :get_artist_info, Tunez.Music.Actions, :get_artist_info
    tool :analyze_artist_sentiment, Tunez.Music.Actions, :analyze_artist_sentiment
  end

  resources do
    resource Tunez.Music.Artist do
      define :create_artist, action: :create
      define :read_artists, action: :read

      define :search_artists,
        action: :search,
        args: [:query],
        default_options: [
          load: [:album_count, :latest_album_year_released, :cover_image_url]
        ]

      define :get_artist_by_id, action: :read, get_by: :id
      define :update_artist, action: :update
      define :destroy_artist, action: :destroy
    end

    resource Tunez.Music.Actions do
      define :analyze_sentiment
      define :analyze_artist_sentiment, args: [:artist_id]
    end

    resource Tunez.Music.Album do
      define :create_album, action: :create
      define :get_album_by_id, action: :read, get_by: :id
      define :update_album, action: :update
      define :destroy_album, action: :destroy
    end
  end
end
