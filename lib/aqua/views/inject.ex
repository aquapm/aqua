defmodule Aqua.Views.Inject do
  alias Aqua.View

  def file_inject(path) do
    View.inline([:cyan, "➤  Creating ", :yellow, "#{path} "])
  end

  defdelegate done(), to: View

  # This is fallback for uncoverd problems
  def panic(problem) do
    View.panic(inspect(problem))
  end
end
