defmodule Aqua.Render do
  def render(iodata) do
    iodata
    |> IO.ANSI.format()
    |> IO.write()
  end
end
