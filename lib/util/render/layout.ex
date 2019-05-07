defmodule Aqua.Render.Layout do
  alias Aqua.Render.Symbols
  alias Aqua.Render.Terms

  def p(ident, iodata) do
    [ident(ident), iodata, "\n"]
  end

  def ul(ident, title, items) do
    [
      "\n",
      ident(ident),
      title,
      "\n\n",
      Enum.map(items, fn list_item ->
        [
          ident(ident),
          Terms.aqua(Symbols.bullet()),
          list_item,
          "\n"
        ]
      end),
      "\n"
    ]
  end

  defp ident(ident_size) do
    String.pad_leading("", ident_size)
  end
end
