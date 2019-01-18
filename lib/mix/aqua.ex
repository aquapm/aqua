defmodule Mix.Tasks.Aqua do
  use Mix.Task

  alias Aqua.Tasks.{New, Help, Add, Proj}

  def run([]), do: Help.aqua()
  def run(["new" | args]), do: New.run(args)
  def run(["add" | args]), do: Add.project_name()
  def run(["proj" | args]), do: Proj.test()
  # def run([_ | args]), do: Help.aqua()

end
