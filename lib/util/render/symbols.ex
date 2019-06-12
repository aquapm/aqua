defmodule Aqua.Render.Symbols do
  @spec fail :: String.t()
  def fail() do
    "✘"
  end

  @spec success :: String.t()
  def success() do
    "✔"
  end

  @spec bullet :: String.t()
  def bullet() do
    "➤"
  end
end
