defmodule Aqua.Schema.LocalTemplate do
  alias Aqua.Cache
  alias Aqua.Github
  alias Aqua.Template.Meta

  defstruct raw_route: nil,
            org: "aquapm",
            repo: nil,
            injection: nil,
            injection_path: nil,
            injection_options: nil,
            template_files_data: nil,
            template_options: nil,
            success_message: "",
            git_clone_url: nil,
            git_update?: false,
            fs_path: nil,
            synced?: :undefined,
            valid?: :ok

  @type t :: [
          raw_route: String.t(),
          org: String.t(),
          repo: String.t(),
          injection: String.t(),
          injection_path: String.t(),
          injection_options: any(),
          template_files_data: any(),
          template_options: any(),
          git_clone_url: String.t(),
          git_update?: true | false,
          fs_path: String.t(),
          synced?: :undefined | true | false,
          valid?: :ok | {:error, any()}
        ]

  @doc """
  Parse route into **Organization name**, **Repository name** and **Injection name**.
  Populates `Aqua.LocalTemplate` structure with this data
  """
  @spec normalize_route(__MODULE__.t()) :: __MODULE__.t()
  def normalize_route(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def normalize_route(%__MODULE__{raw_route: route} = local_template) do
    case parse_route(route) do
      {:ok, org, repo, injection} ->
        %{
          local_template
          | org: org,
            repo: repo,
            injection: injection,
            git_clone_url: Github.generate_clone_url(org, repo),
            fs_path: Cache.generate_path(org, repo)
        }

      {:error, reason} ->
        %{local_template | valid?: {:error, reason}}
    end
  end

  @doc """
  Checks if the injection is presented in route. If it's not - populate struct with error
  """
  def assert_injection_presented(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def assert_injection_presented(%__MODULE__{injection: nil} = local_template) do
    %{local_template | valid?: {:error, :no_injection}}
  end

  def assert_injection_presented(local_template), do: local_template

  defp parse_route(route) do
    case String.split(route, "/") do
      [org, repo] -> parse_injection(org, repo)
      [repo] -> parse_injection("aquapm", repo)
      _ -> {:error, :bad_route}
    end
  end

  defp parse_injection(org, path) do
    case String.split(path, ".") do
      [repo, injection] -> {:ok, org, repo, injection}
      [repo] -> {:ok, org, repo, nil}
      _ -> {:error, :bad_route}
    end
  end

  @doc """
  Downloads repo, if it hasn't been downloaded yet. Does nothing if it's presented.
  """
  def sync_repo(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def sync_repo(
        %__MODULE__{git_clone_url: url, fs_path: fs, org: org, repo: repo, git_update?: update?} =
          lt
      ) do
    case Cache.sync_repo(url, fs, update?, org, repo) do
      :ok -> %{lt | synced?: true}
      {:error, reason} -> %{lt | synced?: false, valid?: {:error, reason}}
    end
  end

  def load_injection(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def load_injection(%__MODULE__{fs_path: fs, injection: injection} = lt) do
    case Meta.get_injection(fs, injection) do
      {:ok, %{"template" => inject_path, "options" => inject_options} = _inject} ->
        %{lt | injection_path: inject_path, injection_options: inject_options}

      error ->
        %{lt | valid?: error}
    end
  end

  def load_template(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def load_template(%__MODULE__{fs_path: fs} = lt) do
    case Meta.get_template(fs) do
      {:ok, %{"files" => files_data, "options" => template_options} = scaffold} ->
        %{lt | template_files_data: files_data, template_options: template_options, success_message: Map.get(scaffold, "success_message")}

      error ->
        %{lt | valid?: error}
    end
  end
end
