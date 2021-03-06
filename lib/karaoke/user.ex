defmodule Karaoke.User do
  use Karaoke.ComponentServer.GenServer

  @components [
      Karaoke.Component.SocketHandler, 
      Karaoke.Component.Reverse
  ]

  @doc """
  When a listener accepts a new TCP connection, it starts a new user
  """
  def start_client() do
    Karaoke.User.Supervisor.start_user()
  end

  @doc """
  Listener hands over the socket to the user process
  """
  def set_socket(pid, socket) do
    GenServer.cast(pid, {:socket, socket})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], []) 
  end

  def init([]) do
    {:ok, %{:components => @components}}
  end

  @doc """
  TCP Message received
  """
  def handle_info({:tcp, _socket, packet}, state) do
    Karaoke.Event.send_event(self(), {:socket_receive, packet})
    {:noreply, state}
  end

  @doc """
    User is now in charge of the socket 
  """
  def handle_cast({:socket, socket}, state) do
    :ok = :inet.setopts(socket, [{:active, :once}])
    state = Dict.put(state, :socket, socket)
    {:noreply, state}
  end


end


