defmodule Aqua.Render.Terms do
  @prefix %{
    elixir: [:magenta, :bright],
    bash: [:light_yellow, :bright],
    fs: [:yellow, :bright],
    aqua: [:light_blue, :bright],
    text: [:cyan, :normal],
    text_highlight: [:light_cyan, :bright],
    initial: [:green, :bright],
    error: [:red, :normal],
    error_highlight: [:red, :bright],
    success: [:green, :normal]
  }

  Enum.each(@prefix, fn {name, prefix} ->
    @spec unquote(name)(iodata :: iodata()) :: iodata()
    def unquote(name)(iodata) do
      [unquote(prefix), iodata, " "]
    end

    @spec unquote(name)(iodata :: iodata(), :no_padding) :: iodata()
    def unquote(name)(iodata, _no_padding) do
      [unquote(prefix), iodata]
    end
  end)
end
