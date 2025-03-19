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

    action :analyze_artist_sentiment, {:array, Sentiment} do
      argument :artist_id, :uuid, allow_nil?: false
      run Tunez.Music.AlbumAnalysis
    end
  end
end
