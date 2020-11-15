defmodule Aqua.Fs do
  @moduledoc """
  Represents helpers for local file system pathes
  """

  alias Aqua.XDG
  @aqua_config_name "aqua.config.json"

  def local_config_path() do
    XDG.config_home()
    |> Path.join(@aqua_config_name)
  end

  @spec clean() :: no_return() | list(String.t())
  @doc """
  Returns list of deleted files or raises
  """
  def clean() do
    XDG.folder_list()
    |> Enum.map(&File.rm_rf!/1)
  end
end
