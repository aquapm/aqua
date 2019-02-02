defmodule Aqua.ProjectParser.Umbrella do
  @moduledoc """
  This module calculates pathes and aliases for umbrella projects.
  """

  alias Aqua.ProjectParser

  def inject_pathes(raw_path, apps_list) do
    case ProjectParser.check_path_type(raw_path) do
      :alias -> alias_to_path(raw_path, apps_list)
      :path -> path_to_alias(raw_path, apps_list)
      :invalid -> {:error, :invalid_path_alias}
    end
  end

  @doc """
  Trying to generate path for alias in umbrella project.

  Alias should start with valid umbrella child application (for ex. `AppName.ModuleName`)

  In this case the path will be `apps/app_name/lib/module_name.ex`
  """
  def alias_to_path(raw_alias, apps) do
    alias_app =
      raw_alias
      |> String.split(".")
      |> Enum.at(0)
      |> Macro.underscore()
      |> String.to_atom()

    case Map.has_key?(apps, alias_app) do
      false ->
        {:error, {:no_sub_app, :alias, Map.keys(apps)}}

      true ->
        # We can add this alias to one of the underline applications
        relative_path = ProjectParser.alias_to_path_part(raw_alias)
        {:ok, {Path.join(Map.get(apps, alias_app), relative_path), raw_alias}}
    end
  end

  def path_to_alias(unchecked_path, apps) do
    expanded_path =
      unchecked_path
      |> Path.expand()
      |> Path.relative_to_cwd()

    case Path.type(expanded_path) do
      :relative -> checked_path_to_alias(expanded_path, apps)
      _ -> {:error, :absolute_path}
    end
  end

  defp checked_path_to_alias(checked_path, apps) do
    # If path does not change - it means that path is not belnogs to this app
    case Enum.filter(apps, fn {_app_name, app_path} ->
           checked_path != Path.relative_to(checked_path, app_path)
         end) do
      # sub application is not found
      [] ->
        {:error, {:no_sub_app, :path, Map.keys(apps)}}

      [{app_name, app_path}] ->
        case Path.relative_to(checked_path, app_path)
             |> ProjectParser.path_part_to_alias() do
          {:ok, module_alias} -> {:ok, {checked_path, module_alias}}
          error -> error
        end
    end
  end

  @doc """
  function will return either path to new generated project root, or error that project name is invalid
  """
  @spec scaffold_pathes(raw_path :: String.t(), app_path :: String.t() | nil) ::
          {:ok, String.t()} | {:error, :bad_project_name}
  def scaffold_pathes(raw_path, apps_path) do
    case ProjectParser.assert_project_name(raw_path) do
      {:ok, project_name} ->
        {:ok,
         {project_name,
          Path.join(apps_path, project_name)
          |> Path.expand()
          |> Path.relative_to_cwd()}}

      error ->
        error
    end
  end
end
