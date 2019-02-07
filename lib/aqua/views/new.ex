defmodule Aqua.Views.List do
  # alias Aqua.View

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
end
