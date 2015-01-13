defmodule Karaoke.Component.SocketHandler do
  @behaviour Karaoke.Component

  @doc """
  Receive a TCP message
  """
  def handle_event({:socket_receive, packet} = _event, state) do
    {:ok, msg} = Msgpax.unpack(packet)
    Karaoke.Event.send_event(self(), {:socket_send, String.reverse(msg)})
    {:ok, {:socket_receive, msg}, state}
  end

  @doc """
  Send a TCP message
  """
  def handle_event({:socket_send, msg} = _event, %{ :socket => socket } = state) do
    {:ok, packet} = Msgpax.pack(msg)
    :ok = :gen_tcp.send(socket, packet)
    {:ok, {:socket_send, msg}, state}
  end

end
