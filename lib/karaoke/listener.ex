defmodule Karaoke.Listener do
  use GenServer
  require Logger

  @doc """
  Starts the TCP listener
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    Logger.debug("Starting the listener")
    sock_opts = [:binary,
      {:reuseaddr, true},
      {:packet, 4},
      {:nodelay, true},
      {:active, false},
      {:keepalive, true},
      {:backlog, 1024},
      {:send_timeout, 20000},
      {:send_timeout_close, true}] 

    port = 3246
    case :gen_tcp.listen(port, sock_opts) do
      {:ok, listen} ->
        {:ok, _ref} = :prim_inet.async_accept(listen, -1)
        {:ok, %{}}
      {:error, Reason} ->
        {:stop, Reason}
    end
    {:ok, %{}}
  end

  def handle_info({:inet_async, listen, _ref, {:ok, socket}}, state) do
    true = :inet_db.register_socket(socket, :inet_tcp)
    #Inherit socket options
    case :prim_inet.getopts(listen, [:active,
      :nodelay,
      :packet,
      :keepalive,
      :send_timeout,
      :send_timeout_close]) do
        {:ok, opts} ->
          case :prim_inet.setopts(socket, opts) do
            :ok ->
              :ok
            error ->
              :gen_tcp.close(socket)
              exit({:failed_setopts, error})
          end
        error ->
          :gen_tcp.close(socket)
          exit({:failed_getopts, error})
      end

      Logger.debug("Connection accepted")
      {:ok, pid} = Karaoke.User.start_client()
      :ok = :gen_tcp.controlling_process(socket, pid)
      Karaoke.User.set_socket(pid, socket)

      case :prim_inet.async_accept(listen, -1) do
        {:ok, _ref} ->
          {:noreply, state} 
        {:error, error} ->
          exit({:failed_accept, :inet.format_error(error)})
      end
  end

end
