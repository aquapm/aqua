defmodule Aqua.Tasks.Proj do
  def test() do
    Mix.Project.config()
    |> IO.inspect
  end
end
