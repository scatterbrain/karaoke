defmodule Karaoke.Utils do
  @doc """
  Convert map string keys to atoms
  """
  def atomify_map_keys(input) when is_map(input) do
    Enum.reduce(input, %{}, fn({key, value}, acc) ->
      Dict.put(acc, String.to_atom(key), atomify_map_keys(value)) 
    end)
  end
  def atomify_map_keys(input), do: input

end
