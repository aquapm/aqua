defmodule Aqua.Cli.Unix do
  def which(executable) do
    case System.cmd("which", [executable]) do
      {path, 0} -> {:ok, Path.expand(String.trim(path))}
      {_, 1} -> {:error, :not_found}
    end
  end
end
