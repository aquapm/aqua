defmodule Aqua.ProjectParser do
  @moduledoc false

  @doc """
  This method will identify incoming path.
  It can be either:

  * FS path: `path/to/file`
  * Module alias name: `MyApp.Namespace.MyModule`
  """
  @spec check_path_type(path :: String.t()) :: :alias | :path | :invalid
  def check_path_type(path) do
    case String.match?(path, ~r/^[\.\w\/].*$/) do
      true ->
        if inspect(Module.concat(Elixir, path)) == path do
          :alias
        else
          :path
        end

      false ->
        :invalid
    end
  end

  @doc """
  Return filepath, relative to flat project, for given alias

  Will put inside `lib` folder
  """
  def alias_to_path_part(raw_alias) do
    Path.join(["lib", Macro.underscore(raw_alias)]) <> ".ex"
  end

  @spec path_part_to_alias(path_part :: String.t()) :: {:ok, atom()} | {:error, :absolute_path}
  def path_part_to_alias("lib") do
    {:error, :absolute_path}
  end

  def path_part_to_alias(path_part) when is_binary(path_part) do
    cleared_path =
      path_part
      # here we cleareing the path from lib folder
      |> Path.relative_to("lib")

    # now we need to inject application name in front to any case
    module_string =
      cleared_path
      # and clear extension
      |> Path.rootname()
      # Now generating module alias
      |> Macro.camelize()

    {:ok, inspect(Module.concat([module_string]))}
  end

  @spec assert_project_name(name :: String.t()) :: {:error, :bad_project_name} | {:ok, String.t()}
  def assert_project_name(name) do
    case String.match?(name, ~r/^\w[\w_]*$/) do
      true -> {:ok, name}
      false -> {:error, :bad_project_name}
    end
  end
end
