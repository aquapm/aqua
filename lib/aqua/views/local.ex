defmodule Aqua.Views.Local do
  alias Aqua.View

  defdelegate success(io_list), to: View

  @spec panic(error :: any()) :: no_return()
  def panic(:editor_not_defined) do
    View.panic([
      "The ",
      :bright,
      :yellow,
      "`EDITOR`",
      :normal,
      :red,
      " system environment variable is not defined!"
    ])
  end

  def panic({:editor_not_found, editor}) do
    View.panic([
      "Editor ",
      :bright,
      :magenta,
      "#{editor}",
      :normal,
      :red,
      " not found!"
    ])
  end

  # This is fallback for uncoverd problems
  def panic(io_list) do
    View.panic(io_list)
  end
end
