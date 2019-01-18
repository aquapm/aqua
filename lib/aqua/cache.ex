defmodule Aqua.Cache do
  alias Aqua.SCM.Git

  alias Aqua.Schema.LocalRepo

  def aqua_path() do
    System.user_home()
    |> Path.join(".aqua")
  end

  def official_list() do
    case File.read(official_list_path()) do
      {:error, _} ->
        {:error, :invalid}

      {:ok, data} ->
        {:ok, :erlang.binary_to_term(data)}
    end
  end

  def update_official_list() do
    data = Aqua.Github.list_all_official_templates()
    path = official_list_path()
    File.mkdir(Path.dirname(path))
    File.write(path, :erlang.term_to_binary(data))
    data
  end

  defp official_list_path do
    aqua_path()
    |> Path.join("official_list.term")
  end

  def generate_path(user, repo) do
    Path.join([aqua_path(), user, repo])
  end

  def clone_repo(route, path) do
    Git.clone()
  end

  def repo_exists?(user, repo) do
    File.dir?(generate_path(user, repo))
  end

  def repo_exists?(%LocalRepo{path: path, cloned?: :undefined} = repo) do
    %{repo | cloned?: File.dir?(path)}
  end

  def repo_exists?(%LocalRepo{} = repo), do: repo

  @doc """
  Syncornizes FS and in-memory repo information
  """
  def sync_repo(repo) do
    case repo_exists?(repo) do
      %{cloned?: true} = repo -> {:ok, repo}
      %{cloned?: false} = repo ->
        IO.write(IO.ANSI.format([:cyan, "➤ Updating template cache: #{repo.route} "]))
        # Mix.Shell.IO.info([:cyan, "➤ Updating template cache: #{repo.route}"])
        case Git.clone_repo(repo) do
          {:ok, _} = result ->
            Mix.Shell.IO.info([:green, "✔ Done", :reset])
            result
          {:error, _} = result ->
            Mix.Shell.IO.info([:red, "✘ Fail", :reset])
            result
        end
    end
  end
end
