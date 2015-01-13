defmodule Karaoke.Component do
  use Behaviour

  @doc "Receives incoming event"
  defcallback handle_event(term, map) :: {atom, map}

end
