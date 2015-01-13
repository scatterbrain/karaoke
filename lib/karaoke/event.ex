defmodule Karaoke.Event do
  def send_event(receiver, msg) do
    send receiver, {:event, msg}
  end

  def run_components([], _event, state) do 
    {:ok, state}
  end

  def run_components([component|components], event, state) do
      case component.handle_event(event, state) do
        {:ok, event, state} ->
          run_components(components, event, state)
        #Any component can stop the event from propagating
        {:stop, event, state} ->
          run_components([], event, state)
      end
  end
end
