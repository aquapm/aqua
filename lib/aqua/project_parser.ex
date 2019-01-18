defmodule Aqua.ProjectParser do
  @spec parse_project(code :: String.t()) ::
          {:ok, Keyword.t()} | {:error, :bad_project} | {:error, :mix_corrupted}
  def parse_project(code) do
    case get_ast(code) do
      {:ok, ast} ->
        {module_name, injected_ast} = patch_module(ast)
        Code.compile_quoted(injected_ast)

        case Kernel.function_exported?(module_name, :project, 0) do
          true -> {:ok, Kernel.apply(module_name, :project, [])}
          false -> {:error, :bad_project}
        end

      {:error, _} ->
        {:error, :mix_corrupted}
    end
  end

  def get_ast(code) do
    Code.string_to_quoted(code)
  end

  @spec name_for_path(binary(), atom()) :: any()
  # Case for absolute path
  def name_for_path(<<"./", path::binary()>>, app_name) do
    # Throwing away "/lib" and generating as is
    case path do
      <<"lib/", cleared_path::binary()>> -> do_name_for_path(cleared_path)
      weird_path -> do_name_for_path(weird_path, app_name)
    end
  end
  def name_for_path(relative, app_name) do
    do_name_for_path(relative, app_name)
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

    case app_name do
      nil -> namespace_path
      atom -> [Atom.to_string(atom) | namespace_path]
    end
    |> Enum.map(fn path_part -> Macro.camelize(path_part) end)
    |> Module.concat()
  end

  def patch_module(
        {:defmodule, defmodule_env, [{:__aliases__, aliases_env, aliases_list}, do_list]}
      ) do
    {
      Module.concat([:Aqua | [:Sandbox | aliases_list]]),
      {:defmodule, defmodule_env,
       [{:__aliases__, aliases_env, [:Aqua | [:Sandbox | aliases_list]]}, patch_do_list(do_list)]}
    }
  end

  defp patch_do_list(do: {:__block__, block_args, do_inner_list}) do
    [do: {:__block__, block_args, Enum.map(do_inner_list, &patch_do_inner/1)}]
  end

  defp patch_do_inner({:use, use_env, [{:__aliases__, aliases_env, [:Mix, :Project]}]}) do
    {:use, use_env, [{:__aliases__, aliases_env, [:Aqua, :SandboxProject]}]}
  end

  defp patch_do_inner(any), do: any
end
