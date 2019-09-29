defmodule Mix.Tasks.Local.Aqua do
  use Mix.Task

  alias Aqua.Views.Local, as: View
  alias Aqua.Editor

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
    with {:ok, editor_command} <- Editor.ensure_environment_specified(),
         {:ok, {editor_path, args}} <- Editor.get_editor(editor_command),
         {:ok, _} <- Editor.run(editor_path, args, Aqua.Config.path()) do
      {:ok, :success}
    else
      {:error, :not_defined} -> View.panic(:editor_not_defined)
      {:error, :not_found} -> View.panic(:editor_not_found)
      {:error, {:edit_failed, exit_status}} -> View.panic({:edit_failed, exit_status})
    end
  end

  def run(_args) do
    Mix.Task.run("archive.install", ["hex", "aqua", "~> 1.0"])
  end
end
