defmodule Karaoke.Component.Reverse do
  @behaviour Karaoke.Component
  def handle_event({:reverse, msg} = _event, %{ :socket => socket } = state) do
    send_msg = %{:str => String.reverse(msg.str)}
    Karaoke.Component.SocketHandler.send_socket(send_msg)
    {:ok, {:socket_send, msg}, state}
  end

  def handle_event(event, state) do
    {:ok, event, state}
  end
end
