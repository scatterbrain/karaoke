defmodule Karaoke.Event do
  def send_event(receiver, msg) do
    send receiver, {:event, msg}
  end

  def run_components(components, event, state) do
    Enum.each(components, fn(component) -> 
      component.handle_event(event, state) 
    end)
  end
end
