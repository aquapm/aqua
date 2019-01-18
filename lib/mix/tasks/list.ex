defmodule Mix.Tasks.Aqua.List do
  use Mix.Task
  alias Aqua.Cache

  @shortdoc "List official project templates"
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
