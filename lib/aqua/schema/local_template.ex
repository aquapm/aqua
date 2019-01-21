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
            git_clone_url: nil,
            fs_path: nil,
            cloned?: :undefined,
            valid?: :ok

  @type t :: [
          raw_route: String.t(),
          org: String.t(),
          repo: String.t(),
          injection: String.t(),
          injection_path: String.t(),
          injection_options: any(),
          git_clone_url: String.t(),
          fs_path: String.t(),
          cloned?: :undefined | true | false,
          valid?: :ok | {:error, any()}
        ]

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

  def sync_repo(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def sync_repo(%__MODULE__{git_clone_url: url, fs_path: fs, org: org, repo: repo} = lt) do
    case File.dir?(fs) do
      false ->
        Mix.Shell.IO.info([:cyan, "➤\tUpdating template cache: #{org}/#{repo} "])

        case Cache.sync_repo(url, fs) do
          :ok ->
            Mix.Shell.IO.info([:green, "✔\tDone"])
            %{lt | cloned?: true}

          {:error, reason} ->
            %{lt | cloned?: false, valid?: {:error, reason}}
        end

      true ->
        %{lt | cloned?: true}
    end
  end

  def load_injection(%__MODULE__{valid?: {:error, _}} = lt), do: lt

  def load_injection(%__MODULE__{fs_path: fs, injection: injection} = lt) do
    case Meta.get_injection(fs, injection) do
      {:ok, %{"template" => inject_path, "options" => inject_options} = inject} ->
        %{lt | injection_path: inject_path, injection_options: inject_options}

      error ->
        %{lt | valid?: error}
    end
  end
end
