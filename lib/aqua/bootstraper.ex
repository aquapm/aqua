defmodule Aqua.Bootstraper do
  @moduledoc false
  def generate(path_to_template, args) do
    Mix.Shell.IO.info(
      "• Generating from #{inspect(path_to_template)} with args: #{inspect(args)}"
    )
  end
end
