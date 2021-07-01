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
    |> IO.ANSI.format()
  end

  @spec verbose(any, atom | pid) :: :ok
  def verbose(iodata, device \\ :stdio) do
    if Application.get_env(:aqua, :verbose) do
      IO.write(device, iodata)
    end
  end

  @spec out(any, atom | pid) :: :ok
  def out(iodata, device \\ :stdio), do: IO.write(device, iodata)
end
