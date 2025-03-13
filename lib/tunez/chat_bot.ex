defmodule Tunez.ChatBot do
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI

  def iex_chat(actor) do
    %{
      llm: ChatOpenAI.new!(%{model: "gpt-4o", stream: true, receive_timeout: :timer.minutes(2)}),
      verbose?: true
    }
    |> LLMChain.new!()
    |> AshAi.iex_chat(actor: actor, otp_app: :tunez)
  end
end
