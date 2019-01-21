defmodule Aqua.Schema.Inject do
  alias Aqua.ProjectParser.Umbrella, as: UmbrellaParser
  alias Aqua.ProjectParser.Flat, as: FlatParser
  alias Aqua.Schema.LocalTemplate

  defstruct raw: "",
            path: "",
            module_name: nil,
            template: nil,
            # :none, :flat, :umbrella
            injection_path: "",
            project_type: :none,
            assigns: %{},
            valid?: :ok

  @type t :: %{
          raw: String.t(),
          path: String.t(),
          module_name: atom(),
          template: any(),
          injection_path: String.t(),
          assigns: Map.t(),
          project_type: :none | :flat | :umbrella,
          valid?: :ok | {:error, atom()}
        }

  @doc """
  Identifies the type of a project. Sets it for `Inject` structure.

  Project structure can be: :none, :flat, :umbrella
  """
  @spec set_project_type(inject :: __MODULE__.t()) :: __MODULE__.t()
  def set_project_type(%__MODULE__{} = inject) do
    case Mix.Project.umbrella?() do
      false ->
        case Mix.Project.get() do
          nil -> Map.put(inject, :project_type, :none)
          _ -> Map.put(inject, :project_type, :flat)
        end

      true ->
        Map.put(inject, :project_type, :umbrella)
    end
  end

  @doc """
  Sets `Inject` to invalid, if the project is :none
  """
  @spec assert_in_project(__MODULE__.t()) :: __MODULE__.t()
  def assert_in_project(%__MODULE__{project_type: :none} = inject),
    do: Map.put(inject, :valid?, {:error, :not_in_project})

  def assert_in_project(%__MODULE__{project_type: _} = inject), do: inject

  @spec calculate_pathes(__MODULE__.t()) :: nil
  def calculate_pathes(%__MODULE__{raw: raw_path, project_type: :umbrella} = inject) do
    # Pathes for umbrella differs from pathes for flat project
    # We are sure, that for umbrella application we have a list of applications (may be empty)
    case UmbrellaParser.pathes(raw_path, Mix.Project.apps_paths()) do
      {:ok, {path, module_name}} ->
        inject
        |> Map.put(:path, path)
        |> Map.put(:module_name, module_name)

      error ->
        Map.put(inject, :valid?, error)
    end
  end

  def calculate_pathes(%__MODULE__{raw: raw_path, project_type: :flat} = inject) do
    # Pathes for umbrella differs from pathes for flat project
    case FlatParser.pathes(raw_path, Mix.Project.config()[:app]) do
      {:ok, {path, module_name}} ->
        inject
        |> Map.put(:path, path)
        |> Map.put(:module_name, module_name)

      error ->
        Map.put(inject, :valid?, error)
    end
  end

  def load_template(%__MODULE__{} = inject, template) do
    case %LocalTemplate{raw_route: template}
         |> LocalTemplate.normalize_route()
         |> LocalTemplate.assert_injection_presented()
         |> LocalTemplate.sync_repo()
         |> LocalTemplate.load_injection() do
      %{valid?: :ok} = template -> %{inject | template: template}
      %{valid?: error} = template -> %{inject | template: template, valid?: error}
    end
  end

  def generate_assigns(
        %__MODULE__{
          project_type: type,
          module_name: module_alias,
          injection_path: injection_path,
          template: template
        } = inject,
        args
      ) do
    assigns =
      Aqua.Assigns.global_assigns(Atom.to_string(Mix.Project.config()[:app]), type == :umbrella)
      |> Map.merge(%{
        module_alias: module_alias,
        injection_path: injection_path
      })

    case Aqua.Options.prepare(args, template) do
      {:ok, arg_assigns} ->
        %{inject | assigns: Map.merge(assigns, arg_assigns)}

      {:error, bad_args} ->
        %{inject | valid?: {:error, {:args, bad_args}}}
    end
  end
end
