defmodule Mix.Tasks.Local.Aqua do
  use Mix.Task

  alias Aqua.Views.Local, as: View

  @moduledoc """
  Local-copy Aqua tasks

  ### Updating local Aqua copy

  Example:
      mix local.aqua

  This accepts the same command line options as `archive.install`.

  ### Opening Aqua config file

  **NOTE**: `$EDITOR` environment variable should be specified in order to succesfully run the command
  Example:
      mix local.aqua config


  """

  @shortdoc "Local-copy Aqua tasks"
  @doc false
  def run(["config" | _args]) do
    case System.get_env("EDITOR") do
      nil ->
        View.panic(:editor_not_defined)

      editor ->
        case String.split(editor) do
          [] ->
            View.panic(:editor_not_defined)

          [editor | args] ->
            case System.cmd("which", [editor]) do
              {"", _} ->
                View.panic({:editor_not_found, editor})

              {_, 1} ->
                View.panic({:editor_not_found, editor})

              {editor_path, _} ->
                port =
                  :erlang.open_port({:spawn_executable, String.trim(editor_path)}, [
                    {:args, args ++ [Aqua.Cache.config_path()]},
                    :exit_status,
                    :nouse_stdio
                  ])

                receive do
                  {^port, {:exit_status, _}} ->
                    View.success(["Config successfully updated!"])
                end
            end
        end
    end
  end

  def run(_args) do
    Mix.Task.run("archive.install", ["hex", "aqua", "~> 0.9"])
  end
end
