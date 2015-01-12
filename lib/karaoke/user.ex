defmodule Karaoke.User do
  use GenServer

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
    GenServer.cast(pid, {:socket, Socket})
  end

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, []) 
  end

  def init(config) do
    {:ok, %{}}
  end
  
  @doc """
    User is now in charge of the socket 
  """
  def handle_cast({:socket, socket}, state) do
    :ok = :inet.setopts(socket, {:active, :once})
    state = Dict.put(state, :socket, socket)
    {:noreply, state}
  end
end

