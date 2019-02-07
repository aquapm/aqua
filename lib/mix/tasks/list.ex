defmodule Aqua.Tasks.List do
  alias Aqua.Cache
  alias Aqua.Views.New, as: View

  def run(_) do
    case Cache.official_list do
      {:error, _} -> Cache.update_official_list()
      {:ok, data} -> data
    end
    |> View.list([])
  end
end
