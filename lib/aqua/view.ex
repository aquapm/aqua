defmodule Aqua.View do
  @spec panic(any()) :: no_return()
  def panic(io_list) do
    Mix.Shell.IO.error([:normal, "✘ " | io_list])
    System.halt(1)
  end

  def inline(io_list) do
    IO.write(IO.ANSI.format(io_list))
  end

  def il(io_list) do
    [:cyan, :bright, "➤  ", io_list]
  end

  def done() do
    Mix.Shell.IO.info([:green, "✔  Done"])
  end
end
