defmodule Aqua.Editor do
  @spec ensure_environment_specified() :: {:error, :not_defined} | {:ok, String.t()}
  def ensure_environment_specified do
    case System.get_env("EDITOR") do
      nil -> {:error, :not_defined}
      editor -> {:ok, editor}
    end
  end

  @spec get_editor(editor_command :: String.t()) ::
          {:error, :not_found} | {:ok, {String.t(), [String.t()]}}
  def get_editor(editor_command) do
    with [editor | args] <- String.split(editor_command),
         {:ok, editor_path} <- Aqua.Cli.which(editor) do
      {:ok, {editor_path, args}}
    else
      _ -> {:error, :not_found}
    end
  end

  @spec run(editor_path :: String.t(), args :: [String.t()], filepath :: String.t()) :: {:error, {:edit_failed, integer}} | {:ok, :success}
  def run(editor_path, args, filepath) do
    # ensuring the folder exists

    File.mkdir_p!(Path.dirname(filepath))

    port =
      :erlang.open_port({:spawn_executable, String.trim(editor_path)}, [
        {:args, args ++ [filepath]},
        :exit_status,
        :nouse_stdio
      ])

    receive do
      {^port, {:exit_status, exit_status}} ->
        case exit_status do
          0 -> {:ok, :success}
          exit_status -> {:error, {:edit_failed, exit_status}}
        end
    end
  end
end
