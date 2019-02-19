defmodule Aqua.Renderer do
  @spec render(any()) :: :ok
  def render(iolist) do
    IO.puts(iolist)
  end
end
