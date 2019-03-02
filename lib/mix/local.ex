defmodule Mix.Tasks.Local.Aqua do
  use Mix.Task

  @shortdoc "Updates Aqua tools"

  @moduledoc """
  Updates Aqua tools
  Example:
      mix local.aqua
  This accepts the same command line options as `archive.install`.
  """
  def run(_args) do
    Mix.Task.run("archive.install", ["hex", "aqua", "~> 0.9"])
  end
end
