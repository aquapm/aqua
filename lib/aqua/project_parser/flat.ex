defmodule Aqua.ProjectParser.Flat do
  @moduledoc """
  This module calculates pathes and aliases for umbrella projects.
  """

  alias Aqua.ProjectParser

  @spec pathes(raw_path :: binary(), app :: atom()) ::
          {:error, :absolute_path} | {:ok, {checked_path :: binary(), module_alias :: atom()}}
  def pathes(raw_path, app) do
    case ProjectParser.check_path_type(raw_path) do
      :alias -> alias_to_path(raw_path, app)
      :path -> path_to_alias(raw_path, app)
    end
  end

  @doc """
  Trying to generate path for alias in umbrella project.

  Alias should start with valid umbrella child application (for ex. `AppName.ModuleName`)

  In this case the path will be `apps/app_name/lib/module_name.ex`
  """
  def alias_to_path(raw_alias, _app) do
    {:ok, {ProjectParser.alias_to_path_part(raw_alias), raw_alias}}
  end

  def path_to_alias(unchecked_path, app) do
    expanded_path =
      unchecked_path
      |> Path.expand()
      |> Path.relative_to_cwd()

    case Path.type(expanded_path) do
      :relative -> checked_path_to_alias(expanded_path, app)
      _ -> {:error, :absolute_path}
    end
  end

  defp checked_path_to_alias(checked_path, _app) do
    case ProjectParser.path_part_to_alias(checked_path) do
      {:ok, module_alias} -> {:ok, {checked_path, module_alias}}
      error -> error
    end
  end
end
