defmodule Aqua.ProjectParser do
  def path_to_alias(path) do
    # case check_path_type(path) do
    #    ->

    # end
    name_for_path(path, Mix.Project.config()[:app])
  end

  @doc """
  This method will identify incoming path.
  It can be either:

  * FS path: `path/to/file`
  * Module alias name: `MyApp.Namespace.MyModule`
  """
  @spec check_path_type(path :: String.t()) :: :alias | :path
  def check_path_type(path) do
    if inspect(Module.concat(Elixir, path)) == path do
      :alias
    else
      :path
    end
  end

  @spec name_for_path(binary(), atom()) :: any()
  # Weird absolute path
  def name_for_path(<<"/", path::binary()>>, _app_name) do
    {:error, :bad_path}
  end

  # Case for relative from current folder path
  def name_for_path(<<"./", path::binary()>>, app_name) do
    # Throwing away "/lib" and generating as is
    module_alias =
      case path do
        <<"lib/", cleared_path::binary()>> -> do_name_for_path(cleared_path)
        weird_path -> do_name_for_path(weird_path, app_name)
      end

    case module_alias do
      {:ok, ma} -> {:ok, {ma, "./" <> path}}
      error -> error
    end
  end

  # Case path is relative absolute - it means that it's already inside `lib` folder
  def name_for_path(relative, app_name) do
    case do_name_for_path(relative, app_name) do
      {:ok, ma} -> {:ok, {ma, "./lib/" <> relative}}
      error -> error
    end
  end

  defp do_name_for_path(path, app_name \\ nil) do
    reversed_path =
      path
      |> String.split("/")
      |> Enum.reverse()

    [filename | namespace] = reversed_path

    normalized_modulename =
      case Enum.reverse(String.split(filename, ".")) do
        [name | []] -> [name]
        [_ext | name] -> name
      end
      |> Enum.reverse()
      |> Enum.join("_")

    namespace_path = [normalized_modulename | namespace] |> Enum.reverse()

    resulting_alias =
      case app_name do
        nil -> namespace_path
        atom -> [Atom.to_string(atom) | namespace_path]
      end
      |> Enum.map(fn path_part -> Macro.camelize(path_part) end)
      |> Module.concat()

    {:ok, resulting_alias}
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
    module_string = cleared_path
    # and clear extension
    |> Path.rootname()
    # Now generating module alias
    |> Macro.camelize()

    {:ok, Module.concat([module_string])}
  end
end
