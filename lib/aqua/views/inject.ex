defmodule Aqua.Views.Inject do
  alias Aqua.View

  def file_inject(path) do
    View.inline([:cyan, "➤  Creating ", :yellow, "#{path} "])
  end

  defdelegate done(), to: View
end
