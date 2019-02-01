defmodule Aqua.ProjectParser.None do
  @moduledoc """
  This module calculates pathes and aliases for not a project.
  """

  alias Aqua.ProjectParser

  @doc """
  function will return either path to new generated project root, or error that project name is invalid
  """
  @spec scaffold_pathes(raw_path :: String.t(), app_path :: String.t() | nil) ::
          {:ok, String.t()} | {:error, :bad_project_name}
  def scaffold_pathes(raw_path, _app_path) do
    case ProjectParser.assert_project_name(raw_path) do
      {:ok, project_name} ->
        {:ok,
         {project_name,
          project_name
          |> Path.expand()
          |> Path.relative_to_cwd()}}

      error ->
        error
    end
  end
end
