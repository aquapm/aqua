defmodule Aqua.Tasks.Cli do
  alias Aqua.Help
  alias Aqua.Cli

  def run([]) do
    Cli.loop()
  end
  def run(_), do: Help.cli()
end
