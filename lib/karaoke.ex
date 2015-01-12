defmodule Karaoke do
  require Logger
  use Application
  def start(_type, _args) do
    Logger.debug("Application starting")
    Karaoke.Supervisor.start_link  
  end
  
  def stop(_) do
    Logger.debug("Application stopping")
  end
end
