defmodule Aqua.Templates do
  alias Aqua.Cache
  alias Aqua.Schema.LocalRepo
  alias Aqua.Cache

  def get(route) do
    case LocalRepo.from_route(route) do
      {:ok, local_repo} ->
        Cache.sync_repo(local_repo)
      error -> error
    end
  end
end
