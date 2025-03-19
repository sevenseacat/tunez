defmodule Tunez.Music.AlbumAnalysis do
  use Reactor, extensions: [Ash.Reactor]

  input(:artist_id)

  read_one :get_artist, Tunez.Music.Artist, :by_id do
    inputs %{id: input(:artist_id)}
    load value([:albums])
  end

  template :generate_text do
    argument :artist, result(:get_artist)
    template """
    # Artist: <%= @artist.name %>

    ## Biography
    <%= @artist.biography %>
    
    ## Albums
    <%= for album <- @artist.albums do %>
    ### <%= album.name %>
    <%= album.description %>
    <% end %>
    """
  end

  action :sentiment_analysis, Tunez.Music.Actions, :analyze_sentiment do
    inputs %{text: result(:generate_text)}
  end

  return :sentiment_analysis
end
