defmodule Aqua.Cli.Win do
  @doc """
  Tries to find full path for executable with given name.

  Returns error if search is unsucessfull or full path to a binary if it's found
  """
  @spec which(binary) :: {:error, :not_found} | {:ok, binary}
  def which(executable) do
    case System.cmd("where", [executable]) do
      {path, 0} -> {:ok, Path.expand(String.trim(path))}
      {_, 1} -> {:error, :not_found}
    end
  end
end
