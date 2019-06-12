defmodule Aqua.Views.Common do
  alias Aqua.Render.Terms, as: T
  alias Aqua.Render.Symbols, as: S
  alias Aqua.Render.Layout, as: L

  @spec done :: iodata()
  def done() do
    L.span(0, [
      T.success(S.success()),
      T.success("Done")
    ])
  end
end
