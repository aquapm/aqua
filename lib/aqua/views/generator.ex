defmodule Aqua.Views.Generator do
  alias Aqua.Views.Common

  alias Aqua.Render.Terms, as: T
  alias Aqua.Render.Symbols, as: S
  alias Aqua.Render.Layout, as: L

  def inject_file(path) do
    L.span(0, [
      T.aqua(S.bullet()),
      T.success("Creating"),
      T.fs(path)
    ])
  end

  defdelegate done(), to: Common

  # This is fallback for uncoverd problems
  def panic(problem) do
    inspect(problem)
  end
end
