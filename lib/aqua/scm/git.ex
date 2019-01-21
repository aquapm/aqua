defmodule Aqua.SCM.Git do

  def clone(git_repo_url, path) when is_binary(git_repo_url) and is_binary(path) do
    git_run(["clone", git_repo_url, path])
  end

  def clone_repo(url, fs) do
    case git_run(["clone", url, fs]) do
      {message, 0} ->
        {:ok, message}
      {reason, _error_number} -> {:error, Enum.at(String.split(reason, "ERROR: "), 1)}
    end
  end

  defp git_run(args) do
    System.cmd("git", args, stderr_to_stdout: true)
  end
end
