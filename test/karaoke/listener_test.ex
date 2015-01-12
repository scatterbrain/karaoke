defmodule Karaoke.ListenerTest do
  use ExUnit.Case, async: true

  test "spawns listener" do
    {:ok, _listener} = Karaoke.Listener.start_link
  end
end
