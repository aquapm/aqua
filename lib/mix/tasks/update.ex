defmodule Mix.Tasks.Aqua.Update do
  use Mix.Task
  alias Aqua.Cache

  @shortdoc "List official project templates"
  def run(_) do
    Cache.update_official_list()
    Mix.Shell.IO.info("Official templates list updated")
  end
end
