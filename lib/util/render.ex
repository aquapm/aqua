defmodule Aqua.Render do
  def render(iodata) do
    iodata
    |> IO.ANSI.format()
  end

  def out(iodata, device \\ :stdio), do: IO.write(device, iodata)
end
