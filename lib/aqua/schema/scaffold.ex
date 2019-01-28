defmodule Aqua.Schema.Scaffold do
  @moduledoc """



  * mix aqua new console my_proj --no-test --force
  """

  alias Aqua.ProjectParser.Umbrella, as: UmbrellaParser
  alias Aqua.ProjectParser.Flat, as: FlatParser
  alias Aqua.ProjectParser.None, as: NoneParser

  alias Aqua.Cache
  alias Aqua.Github
  alias Aqua.Template.Meta

  defstruct raw: nil,
            project_name: nil,
            path: nil,
            template: nil,
            project_type: :none,
            assigns: %{},
            valid?: :ok

  @type t :: %__MODULE__{
          raw: nil,
          project_name: String.t(),
          template: any(),
          assigns: Map.t(),
          project_type: :umbrella | :standalone,
          valid?: :ok | {:error, atom()}
        }

  @doc """
  Identifies the type of a project, on which the `mix aqua` command is called.
  Set the valuse inside `Inject` structure under **project_type**.

  Project structure can be:

  * **:none** - we are not inside the project;
  * **:flat** - we are inside flat *[common]* project;
  * **:umbrella** - we are inside **umbrella** project;
  """
  @spec set_project_type(inject :: __MODULE__.t()) :: __MODULE__.t()
  def set_project_type(%__MODULE__{valid?: {:error, _}} = scaffold), do: scaffold

  def set_project_type(%__MODULE__{} = scaffold) do
    case Mix.Project.umbrella?() do
      false ->
        case Mix.Project.get() do
          nil -> Map.put(scaffold, :project_type, :none)
          _ -> Map.put(scaffold, :project_type, :flat)
        end

      true ->
        Map.put(scaffold, :project_type, :umbrella)
    end
  end

  @doc """
  Sets `Scaffold` to invalid, if the value of **project_type** is **:адфе**.

  If the **project_type** value is anything else - pathes the `Inject` struct as is.
  """
  @spec assert_not_in_flat_project(__MODULE__.t()) :: __MODULE__.t()
  def assert_not_in_flat_project(%__MODULE__{valid?: {:error, _}} = scaffold), do: scaffold

  def assert_not_in_flat_project(%__MODULE__{project_type: :flat} = scaffold),
    do: Map.put(scaffold, :valid?, {:error, :already_in_project})

  def assert_not_in_flat_project(%__MODULE__{project_type: _} = scaffold), do: scaffold

  @doc """
  Calculate pathes for scaffolding project. Pathes for umbrella differs from pathes for flat project.

  Function will populate fils-system root path for scaffolding project under **:path** key;

  Calculation is preformed from value of **:raw** key inside `Inject`. We should be inside either umbrella or no application.

  This function as the result either will populate structure with pathes, or invalidate the `Inject` with well-formed error, if path or Elixir's module name
  from raw input are invalid for this type of a project and injection.
  """
  @spec calculate_pathes(__MODULE__.t()) :: __MODULE__.t()
  def calculate_pathes(%__MODULE__{valid?: {:error, _}} = inject), do: inject

  def calculate_pathes(%__MODULE__{raw: raw_path, project_type: :umbrella} = inject) do
    # We are sure, that for umbrella application we have a list of applications (may be empty)
    case UmbrellaParser.scaffold_path(raw_path, Mix.Project.apps_paths()) do
      {:ok, {path, project_name}} ->
        inject
        |> Map.put(:path, path)
        |> Map.put(:project_name, project_name)

      error ->
        Map.put(inject, :valid?, error)
    end
  end

  def calculate_pathes(%__MODULE__{raw: raw_path, project_type: :none} = inject) do
    case NoneParser.scaffold_pathes(raw_path, Mix.Project.config()[:app]) do
      {:ok, {path, project_name}} ->
        inject
        |> Map.put(:path, path)
        |> Map.put(:project_name, project_name)

      error ->
        Map.put(inject, :valid?, error)
    end
  end
end
