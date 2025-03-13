defmodule Tunez.Music.Actions do
  use Ash.Resource, extensions: [AshAi], domain: Tunez.Music

  actions do
    action :analyze_sentiment, :atom do
      constraints(one_of: [:positive, :negative])

      description("""
      Analyzes the sentiment of a given piece of text to determine 
      if it is overall positive or negative.
      """)

      argument :text, :string do
        allow_nil?(false)
        description("The text for analysis")
      end

      run(prompt(
      LangChain.ChatModels.ChatOpenAI.new!(%{model: "gpt-4o"}), 
      tools: true))
    end

    action :analyze_artist_sentiment, :atom do
      constraints(one_of: [:positive, :negative])
      argument(:artist_name, :string, allow_nil?: false)

      description(
        """
        Analyze overall the sentiment of the info about an artists 
        and all their related albums.
        """
      )

      run( prompt( LangChain.ChatModels.ChatOpenAI.new!(%{ model: "gpt-4o" }), tools: true)
      )
    end
  end
end
