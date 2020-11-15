defmodule Aqua.CLI do
  @doc """
  Function tries to find executable by its name or path:

  * **success** - returns absolute path.

  * **fail** - returns `:not_found`.

  ### Examples

      iex> Aqua.Cli.which("ls")
      {:ok, "/bin/ls"}

      iex> Aqua.Cli.which("mix")
      {:ok, "/users/aqua/.asdf/shims/mix"}

      iex> Aqua.Cli.which("keks")
      {:error, :not_found}
  """
  @spec which(executable :: String.t()) ::
          {:ok, absolute_path :: String.t()} | {:error, :not_found}
  def which(executable) do
    case :os.type() do
      {:unix, _} ->
        Aqua.Cli.Unix.which(executable)

      {:win32, _} ->
        Aqua.Cli.Win.which(executable)
    end
  end
end

defmodule Aqua.Cli.Unix do
  def which(executable) do
    case System.cmd("which", [executable]) do
      {path, 0} -> {:ok, Path.expand(String.trim(path))}
      {_, 1} -> {:error, :not_found}
    end
  end
end

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
