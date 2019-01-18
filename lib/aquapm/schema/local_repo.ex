defmodule Aqua.Schema.LocalRepo do
  alias Aqua.Cache
  alias Aqua.Github

  defstruct route: nil,
            git_clone_url: nil,
            path: nil,
            cloned?: :undefined

  defp normalize_route(route) do
    case String.split(route, "/") do
      [user, repo] -> {:ok, {user, repo}}
      [repo] -> {:ok, {"aquapm", repo}}
      _ -> {:error, :invalid_route}
    end
  end

  def from_route(route) do
    case normalize_route(route) do
      {:ok, {user, repo}} ->
        {
          :ok,
          %__MODULE__{
            route: "#{user}/#{repo}",
            git_clone_url: Github.generate_clone_url(user, repo),
            path: Cache.generate_path(user, repo),
            cloned?: Cache.repo_exists?(user, repo)
          }
        }

      error ->
        error
    end
  end
end
