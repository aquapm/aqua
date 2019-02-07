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
    case git_run(["-C", fs, "fetch", "origin", "master"]) do
      {_message, 0} ->
        case git_run(["-C", fs, "reset", "--hard", "origin/master"]) do
          {message, 0} -> {:ok, message}
          error -> decorate_error(error)
        end

      error ->
        decorate_error(error)
    end
  end

  defp git_run(args) do
    System.cmd("git", args, stderr_to_stdout: true)
  end

  @spec decorate_error(error :: {any(), integer()}) :: {:error, any()}
  defp decorate_error({reason, _error_code}) do
    {:error,
     String.split(reason, ["ERROR: ", "fatal: "])
     |> Enum.reverse()
     |> Enum.at(0)}
  end
end
