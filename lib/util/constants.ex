defmodule Aqua.Constants do
  @doc """
  Returns Aqua's folder name.
  Used for file-system operations, connected with XDG pathes
  """
  @spec aqua_folder() :: String.t()
  def aqua_folder do
    "aqua"
  end


  @doc """
  Returns Aqua's config filename
  """
  @spec config_filename() :: String.t()
  def config_filename do
    "config.json"
  end
end
