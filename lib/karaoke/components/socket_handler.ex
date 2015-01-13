defmodule Karaoke.Component.SocketHandler do
  @behaviour Karaoke.Component
  require Logger

  """
  Event Handlers
  """

  @doc """
  Receive a TCP message
  """
  def handle_event({:socket_receive, packet} = _event, state) do
    msg = Msgpax.unpack(packet) |> atomify_keys
    Karaoke.Event.send_event(self(), {String.to_atom(msg.cmd), msg.data})
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

  def handle_event(event, state) do
    {:ok, event, state}
  end

  """
  Utils
  """
  @doc """
  Send to caller's own socket
  """
  def send_socket(msg) do
    Karaoke.Event.send_event(self(), {:socket_send, msg})
  end

  """
  Private utils
  """

  defp atomify_keys({:ok, msgpack_map}) do
    Karaoke.Utils.atomify_map_keys(msgpack_map) 
  end

end
