defmodule Aqua.View do

  @spec panic(any()) :: no_return()
  def panic(io_list) do
    Mix.Shell.IO.error([:normal, "✘ " | io_list])
    System.halt(1)
  end

  def il(io_list) do
    [:cyan, :bright, "➤\t", io_list]
  end
end
