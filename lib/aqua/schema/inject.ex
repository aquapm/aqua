defmodule Aqua.Schema.Inject do
  alias Aqua.ProjectParser.Umbrella, as: UmbrellaParser
  alias Aqua.ProjectParser.Flat, as: FlatParser
  alias Aqua.Schema.LocalTemplate

  alias Aqua.Views.Inject, as: View

  defstruct raw: "",
            path: "",
            module_name: nil,
            template: nil,
            # :none, :flat, :umbrella
            project_type: :none,
            assigns: %{},
            valid?: :ok

  @type t :: %__MODULE__{
          raw: String.t(),
          path: String.t(),
          module_name: atom(),
          template: any(),
          assigns: Map.t(),
          project_type: :none | :flat | :umbrella,
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
  def set_project_type(%__MODULE__{valid?: {:error, _}} = inject), do: inject

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
  Sets `Inject` to invalid, if the value of **project_type** is **:none**.

  If the **project_type** value is anything else - pathes the `Inject` struct as is.
  """
  @spec assert_in_project(__MODULE__.t()) :: __MODULE__.t()
  def assert_in_project(%__MODULE__{valid?: {:error, _}} = inject), do: inject

  def assert_in_project(%__MODULE__{project_type: :none} = inject),
    do: Map.put(inject, :valid?, {:error, :not_in_project})

  def assert_in_project(%__MODULE__{project_type: _} = inject), do: inject

  @doc """
  Calculate pathes for injecting file. Pathes for umbrella differs from pathes for flat project.

  Function will populate:

  * fils-system path of injecting file under **:path** key;
  * module_name for injecting module under **:module_name** key;

  Calculation is preformed from value of **:raw** key inside `Inject`. Raw path can *either* be file-system **OR** valid Elixir's module name.

  This function as the result either will populate structure with pathes, or invalidate the `Inject` with well-formed error, if path or Elixir's module name
  from raw input are invalid for this type of a project and injection.
  """
  @spec calculate_pathes(__MODULE__.t()) :: __MODULE__.t()
  def calculate_pathes(%__MODULE__{valid?: {:error, _}} = inject), do: inject

  def calculate_pathes(%__MODULE__{raw: raw_path, project_type: :umbrella} = inject) do
    # We are sure, that for umbrella application we have a list of applications (may be empty)
    case UmbrellaParser.inject_pathes(raw_path, Mix.Project.apps_paths()) do
      {:ok, {path, module_name}} ->
        inject
        |> Map.put(:path, path)
        |> Map.put(:module_name, module_name)

      error ->
        Map.put(inject, :valid?, error)
    end
  end

  def calculate_pathes(%__MODULE__{raw: raw_path, project_type: :flat} = inject) do
    case FlatParser.inject_pathes(raw_path, Mix.Project.config()[:app]) do
      {:ok, {path, module_name}} ->
        inject
        |> Map.put(:path, path)
        |> Map.put(:module_name, module_name)

      error ->
        Map.put(inject, :valid?, error)
    end
  end

  @doc """
  Loads `LocalTemplate`, and stores it inside **:template** key inside.

  Populates errors, that appears during `LocalTemplates` loading from `LocalTemplate` struct into
  `Inject` struct.

  Can return either `Inject` struct with populated valid `LocalTemplate` under **:template** key,
  or `Inject` with well-formed error under **:valid?** key.
  """
  @spec load_template(__MODULE__.t(), any()) :: __MODULE__.t()
  def load_template(%__MODULE__{valid?: {:error, _}} = inject, _template), do: inject

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

  @doc """
  This function populate generic assigns, that will be used inside injected document
  """
  def generate_assigns(%__MODULE__{valid?: {:error, _}} = inject, _args), do: inject

  def generate_assigns(
        %__MODULE__{
          project_type: type,
          module_name: module_alias,
          path: path,
          template: template
        } = inject,
        args
      ) do
    assigns =
      Aqua.Assigns.global_assigns(Atom.to_string(Mix.Project.config()[:app]), type == :umbrella)
      |> Map.merge(%{
        module_alias: module_alias,
        path: path
      })

    case OptionParser.parse!(args, Aqua.Options.populate_strict(template.injection_options))
         |> elem(0)
         |> Aqua.Options.validate_required_opts(template.injection_options) do
      {:ok, arg_assigns} ->
        %{inject | assigns: Map.merge(assigns, Enum.into(arg_assigns, %{}))}

      {:error, bad_args} ->
        %{inject | valid?: {:error, {:args, bad_args}}}
    end
  end

  # TODO: Rewrite this crazy method!
  def generate(%__MODULE__{valid?: {:error, _}} = inject), do: inject

  def generate(
        %__MODULE__{
          path: to_path,
          template: %{injection_path: from_path, fs_path: prefix_from_path},
          assigns: assigns
        } = inject
      ) do
    try do
      output = EEx.eval_file(Path.join(prefix_from_path, from_path), assigns: assigns)

      with false <- assigns[:force],
           true <- File.exists?(to_path),
           false <- Aqua.View.safe_yes?([:red, :bright, "⚠ ", :normal, " File already exists. Override?"]) do
        inject
      else
        _ ->
          View.file_inject(Path.relative_to(to_path, File.cwd!()))

          case File.mkdir_p(Path.dirname(to_path)) do
            :ok ->
              case File.write(to_path, output) do
                :ok ->
                  View.done()
                  inject

                {:error, _error} ->
                  {:error, :file_create}
              end

            {:error, _error} ->
              {:error, :file_create}
          end
      end
    rescue
      error ->
        %{inject | valid?: {:error, {:gen, error}}}
    end
  end
end
