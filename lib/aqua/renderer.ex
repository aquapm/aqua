defmodule Aqua.Renderer do
  @moduledoc false
  @spec render(any()) :: :ok
  def render(iolist) do
    IO.puts(iolist)
  end
end
