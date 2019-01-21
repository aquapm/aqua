defmodule Mix.Tasks.Aqua do
  use Mix.Task

  alias Aqua.Tasks.{New, Help, Add}

  @spec run(list(String.t())) :: any()
  def run([]), do: Help.aqua()
  def run(["new" | args]), do: New.run(args)
  def run(["add" | args]), do: Add.run(args)
  def run([_ | args]), do: Help.aqua()
end
