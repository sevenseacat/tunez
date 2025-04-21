defmodule Tunez.Music do
  use Ash.Domain, otp_app: :tunez, extensions: [AshGraphql.Domain, AshJsonApi.Domain, AshPhoenix]

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

      create Tunez.Music.ArtistFollower, :follow_artist, :create
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

  forms do
    form :create_album, args: [:artist_id]
  end

  resources do
    resource Tunez.Music.Artist do
      define :create_artist, action: :create
      define :read_artists, action: :read
      define :get_artist_by_id, action: :read, get_by: :id
      define :update_artist, action: :update
      define :destroy_artist, action: :destroy

      define :search_artists,
        action: :search,
        args: [:query],
        default_options: [
          load: [
            :follower_count,
            :followed_by_me,
            :album_count,
            :latest_album_year_released,
            :cover_image_url
          ]
        ]
    end

    resource Tunez.Music.Album do
      define :create_album, action: :create
      define :get_album_by_id, action: :read, get_by: :id
      define :update_album, action: :update
      define :destroy_album, action: :destroy
    end

    resource Tunez.Music.Track

    resource Tunez.Music.ArtistFollower do
      define :follow_artist do
        action :create
        args [:artist]

        custom_input :artist, :struct do
          constraints instance_of: Tunez.Music.Artist
          transform to: :artist_id, using: & &1.id
        end
      end

      define :unfollow_artist do
        action :destroy
        args [:artist]
        get? true

        custom_input :artist, :struct do
          constraints instance_of: Tunez.Music.Artist
          transform to: :artist_id, using: & &1.id
        end
      end

      define :followers_for_artist, action: :for_artist, args: [:artist_id]
    end
  end
end
