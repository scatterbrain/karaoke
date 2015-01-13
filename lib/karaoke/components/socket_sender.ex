defmodule Karaoke.Component.SocketSender do
  @behaviour Karaoke.Component

  @doc """
  Send a TCP message
  """
  def handle_event({:socket_send, msg}, %{ :socket => socket } = _state) do
    :ok = :gen_tcp.send(socket, msg) 
  end

end
