defmodule Karaoke.Supervisor do
  use Supervisor
  
  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Karaoke.Listener, [[]]),
      supervisor(Karaoke.User.Supervisor, [[name: :karaoke_user_sup]])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
