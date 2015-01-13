defmodule KaraokeIntegrationTest do
  use ExUnit.Case

  setup do
    :application.stop(:karaoke)
    :ok = :application.start(:karaoke)
  end

  setup do
    opts = [:binary, packet: 4, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 3246, opts)
    {:ok, socket: socket}
  end

  test "server interaction", %{socket: socket} do
    assert send_and_recv(socket, %{:cmd => :reverse, :data => %{:str => "Echo"}}).str == String.reverse("Echo")
  end

  defp send_and_recv(socket, command) do
    {:ok, packet} = Msgpax.pack(command)    
    :ok = :gen_tcp.send(socket, packet)
    {:ok, packet} 
    case :gen_tcp.recv(socket, 0, 1000) do
      {:ok, packet} ->
        {:ok, data} = Msgpax.unpack(packet)
        Karaoke.Utils.atomify_map_keys(data)
      error ->
        #Give the logger time to print the error before proceeding to the error
        :timer.sleep 1000      
        raise error
    end
  end
end
