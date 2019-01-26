defmodule Aqua.Views.New do
  def panic(error) do
    IO.inspect(:error)
    System.halt(1)
  end
end
