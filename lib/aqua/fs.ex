defmodule Aqua.Fs do
  @aqua_folder_path "~/.aqua"
  @aqua_config_path "config.json"

  @doc """
  Returns path for Aqua local configuration file
  It's generally located ar ~/.aqua/config.json
  """
  def aqua_config_path do
    @aqua_folder_path
    |> Path.join(@aqua_config_path)
    |> Path.expand()
  end
end
