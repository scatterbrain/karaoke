defmodule Karaoke.User.Supervisor do
  use Supervisor
  
  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Users are added dynamically to the supervisor as they come online
  """
  def start_user() do
    Supervisor.start_child(:karaoke_user_sup, []) 
  end

  def init(:ok) do
    children = [
      worker(Karaoke.User, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
