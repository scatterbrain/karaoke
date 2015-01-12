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
    assert send_and_recv(socket, "Echo") == "Echo"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
