defmodule Aqua.Views.Update do
  alias Aqua.View

  def panic({:git, reason}) do
    View.panic(["Fail!\n", reason])
  end

  # This is fallback for uncoverd problems
  def panic(problem) do
    View.panic(inspect(problem))
  end
end
