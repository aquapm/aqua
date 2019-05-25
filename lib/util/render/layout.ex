defmodule Aqua.Render.Layout do
  alias Aqua.Render.Symbols
  alias Aqua.Render.Terms

  @spec p(non_neg_integer, iodata()) :: iodata()
  def p(ident, iodata) do
    [ident(ident), iodata, "\n"]
  end

  @spec span(non_neg_integer, iodata()) :: iodata()
  def span(ident, iodata) do
    [ident(ident), iodata]
  end

  @spec ul(non_neg_integer, iodata(), [iodata()]) :: iodata()
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
