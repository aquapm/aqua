defmodule Mix.Tasks.Aqua do
  @moduledoc false
  use Mix.Task

  alias Aqua.Tasks.{New, Help, Add, Update, List}

  @doc false
  @spec run(list(String.t())) :: any()
  def run([]), do: Help.aqua()
  def run(["new" | args]), do: New.run(args)
  def run(["add" | args]), do: Add.run(args)
  def run(["update" | args]), do: Update.run(args)
  def run(["list" | args]), do: List.run(args)
  def run(["help" | args]), do: Help.run(args)
  def run([_ | _args]), do: Help.aqua()
end
