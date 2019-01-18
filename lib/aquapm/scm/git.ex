defmodule Aqua.SCM.Git do
  alias Aqua.Schema.LocalRepo

  def clone(git_repo_url, path) when is_binary(git_repo_url) and is_binary(path) do
    git_run(["clone", git_repo_url, path])
  end

  def clone_repo(%LocalRepo{path: path, git_clone_url: git_clone_url} = repo) do
    case git_run(["clone", git_clone_url, path]) do
      {_, 0} -> {:ok, %{repo | cloned?: true}}
      {reason, _error_number} -> {:error, Enum.at(String.split(reason, "ERROR: "), 1)}
    end
  end

  defp git_run(args) do
    System.cmd("git", args, stderr_to_stdout: true)
  end
end
