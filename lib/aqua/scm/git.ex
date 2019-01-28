defmodule Aqua.SCM.Git do
  def clone(git_repo_url, path) when is_binary(git_repo_url) and is_binary(path) do
    git_run(["clone", git_repo_url, path])
  end

  def clone_repo(url, fs) do
    case git_run(["clone", url, fs]) do
      {message, 0} -> {:ok, message}
      error -> decorate_error(error)
    end
  end

  def pull_repo(fs) do
    case git_run(["-C", fs, "pull", "-f"]) do
      {message, 0} -> {:ok, message}
      error -> decorate_error(error)
    end
  end

  defp git_run(args) do
    System.cmd("git", args, stderr_to_stdout: true)
  end

  @spec decorate_error(error :: {any(), integer()}) :: {:error, any()}
  defp decorate_error({reason, _error_code}) do
    with nil <- Enum.at(String.split(reason, "ERROR: "), 1),
         nil <- Enum.at(String.split(reason, "fatal: "), 1) do
      {:error, reason}
    else
      value -> {:error, value}
    end
  end
end
