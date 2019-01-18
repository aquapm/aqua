defmodule Aqua.Tasks.Help do
  def aqua() do
    Mix.Shell.IO.info([:blue, "▽\t", :cyan, "Aqua"])
  end

  def new() do
    Mix.Shell.IO.info([:blue, "This is `new` help"])
  end
end
