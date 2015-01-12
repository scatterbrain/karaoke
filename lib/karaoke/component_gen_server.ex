defmodule Karaoke.ComponentServer.GenServer do
  @moduledoc """
  Predefine that relies on `GenServer` provided by Elixir standard
  lib. 
  Example:
  defmodule MyServer do
  use Karaoke.ComponentServer.GenServer
  ...
  end
  """
  defmacro __using__(_opts) do
    quote do
      use GenServer

      @doc """
      Event received
      """
      def handle_info({:event, event}, state) do
        Karaoke.Event.run_components(state.components, event, state)
        {:noreply, state}
      end
    end
  end
end
