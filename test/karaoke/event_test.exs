defmodule Karaoke.EventTest do
  use ExUnit.Case, async: true

  test "run components returns modified state" do
    {:ok, state} = Karaoke.Event.run_components([Karaoke.Component.TestComponent], {:test, {}}, %{})
    assert state.ran == :ok
  end

  test "run components stops on component that returns stop" do
    {:ok, state} = Karaoke.Event.run_components([Karaoke.Component.StoppingTestComponent, Karaoke.Component.TestComponent], {:test, {}}, %{})
    assert state.ran == :not_ok
  end
end

defmodule Karaoke.Component.TestComponent do
  @behaviour Karaoke.Component

  def handle_event({:test, {}} = event, _state) do
    state = %{:ran => :ok}
    {:ok, event, state}
  end
end

defmodule Karaoke.Component.StoppingTestComponent do
  @behaviour Karaoke.Component

  @doc "return a stop meanng that no component after this one will run"
  def handle_event({:test, {}} = event, _state) do
    state = %{:ran => :not_ok}
    {:stop, event, state}
  end
end
