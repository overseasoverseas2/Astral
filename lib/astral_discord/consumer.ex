defmodule AstralDiscord.Consumer do
  @moduledoc """
  Consumes events from the Discord API connection
  """

  require Logger
  use Nostrum.Consumer

  def handle_event({:READY, _data, _ws_state}) do
    AstralDiscord.Interactions.register_commands()

    Nostrum.Api.update_status(:online, "Astral")

    Logger.info("Astral Discord service started!")
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    AstralDiscord.Interactions.handle_interaction(interaction)
  end

  def handle_event({_event, _data, _ws}) do
    :noop
  end
end
