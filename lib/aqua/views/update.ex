defmodule Aqua.Views.Update do
  alias Aqua.View

  def panic({:git, reason}) do
    View.panic(["Fail!\n", reason])
  end
end
