defmodule Aqua.Config do
  alias Aqua.Constants, as: Const

  @doc """
  Returns absolute path for Aqua local config file
  """
  @spec path() :: String.t()
  def path do
    Aqua.XDG.config_home()
    |> Path.join(Const.aqua_folder())
    |> Path.join(Const.config_filename())
  end
end
