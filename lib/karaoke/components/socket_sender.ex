defmodule Karaoke.Component.SocketSender do
  @behaviour Karaoke.Component

  @doc """
  Send a TCP message
  """
  def handle_event({:socket_send, msg} = event, %{ :socket => socket } = state) do
    :ok = :gen_tcp.send(socket, msg)
    {:ok, {:socket_send, msg}, state}
  end

end
