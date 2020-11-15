defmodule Aqua.Render do
  defmacro __using__(_opts) do
    quote location: :keep do
      alias Aqua.Render.Terms, as: T
      alias Aqua.Render.Symbols, as: S
      alias Aqua.Render.Layout, as: L
    end
  end


  def render(iodata) do
    iodata
    |> IO.ANSI.format(true)
  end

  @spec out(any, atom | pid) :: :ok
  def out(iodata, device \\ :stdio), do: IO.write(device, iodata)
end
