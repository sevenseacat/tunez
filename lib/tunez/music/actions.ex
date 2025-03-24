defmodule Tunez.Music.Actions do
  use Ash.Resource, extensions: [AshAi], domain: Tunez.Music

  defmodule Sentiment do
    defstruct [:snippet, :analysis]

    use Ash.Type.NewType,
      subtype_of: :struct,
      constraints: [
        instance_of: __MODULE__,
        fields: [
          snippet: [type: :string, allow_nil?: false],
          analysis: [
            type: :atom,
            constraints: [one_of: [:positive, :negative, :neutral]],
            allow_nil?: false
          ]
        ]
      ]
  end

  actions do
    action :analyze_sentiment, {:array, Sentiment} do
      description """
      Analyzes the sentiment of a given piece of text to determine 
      if it is overall positive or negative.

      Provide example text snippets and their sentiments.
      """

      argument :text, :string do
        allow_nil? false
        description "The text for analysis"
      end

      run prompt(LangChain.ChatModels.ChatOpenAI.new!(%{model: "gpt-4o"}), [])
    end

    action :get_artist_info, :string do
      argument :artist_id, :uuid, allow_nil?: false

      run fn input, _ -> 
        artist = Tunez.Music.get_artist_by_id!(input.arguments.artist_id, load: :albums)

        {:ok, EEx.eval_string(
        """
        # Artist: <%= @artist.name %>

        ## Biography
        <%= @artist.biography %>
        
        ## Albums
        <%= for album <- @artist.albums do %>
        ### <%= album.name %>
        <%= album.description %>
        <% end %>
        """, assigns: %{artist: artist})}
      end
      

    end

    action :analyze_artist_sentiment, {:array, Sentiment} do
      argument :artist_id, :uuid, allow_nil?: false
      description  """
      Analyzes the sentiment of the given artist_id.
      """

      run prompt(LangChain.ChatModels.ChatOpenAI.new!(%{model: "gpt-4o"}), [tools: :get_artist_info])
    end
  end
end
