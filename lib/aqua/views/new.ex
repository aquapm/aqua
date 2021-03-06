defmodule Aqua.Views.List do
  @moduledoc false
  alias Aqua.View

  def list(official, _cached) do
    Mix.Shell.IO.info([
      :light_blue,
      :bright,
      "\tAqua ",
      :normal,
      :cyan,
      "has at the moment next predefined templates:",
      "\n\n",
      Enum.map(official, fn %{name: name, short_desc: desc} ->
        tr(name, desc)
      end)
    ])
  end

  @doc """
  Generates table row for name | description pair
  """
  def tr(name, desc) do
    [
      :magenta,
      String.pad_leading(name, 20),
      :light_blue,
      :bright,
      " | ",
      :normal,
      :cyan,
      desc,
      "\n"
    ]
  end

  # This is fallback for uncoverd problems
  def panic(problem) do
    View.panic(inspect(problem))
  end
end
