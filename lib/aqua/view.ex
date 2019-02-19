defmodule Aqua.View do
  @spec panic(any()) :: no_return()

  # TODO: Set these colors everywhere where needed. Issue #3
  # @colors [
  #   elixir: [:magenta, :bright],
  #   bash: [:light_yellow, :bright],
  #   fs: [:yellow, :bright],
  #   aqua: [:light_blue, :bright],
  #   text: [:cyan, :normal]
  # ]

  def panic(io_list) do
    Mix.Shell.IO.error([:normal, "✘ " | io_list])
    System.halt(1)
  end

  def inline(io_list) do
    IO.write(IO.ANSI.format(io_list))
  end

  def il(io_list) do
    [:cyan, :bright, "➤  ", :normal, io_list]
  end

  def done() do
    Mix.Shell.IO.info([:green, "✔  Done"])
  end

  def yes?(message) do
    answer = IO.gets(IO.ANSI.format([message, :magenta, :bright, " [Yn] "]))
    is_binary(answer) and String.trim(answer) in ["", "y", "Y", "yes", "YES", "Yes"]
  end
end
