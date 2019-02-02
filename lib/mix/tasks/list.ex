defmodule Aqua.Tasks.List do
  alias Aqua.Cache

  def run(_) do
    case Cache.official_list do
      {:error, _} -> Cache.update_official_list()
      {:ok, data} -> data
    end
    |> Enum.each(fn %{name: name, short_desc: desc} ->
      Mix.Shell.IO.info("#{name}\t\t#{desc}")
    end)
  end
end
