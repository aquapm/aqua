defmodule Aqua.ModulePathConverter do
  @doc """
  Identifies raw string as path or module

  Returns `:alias` if the string is valid Elixir module name.
  Returns `:path` in other cases
  """
  @spec identify_type(raw_data :: String.t()) :: :path | :alias
  def identify_type(raw_data) do
    if inspect(Module.concat(Elixir, raw_data)) == raw_data do
      :alias
    else
      :path
    end
  end

  @doc """
  Converts `:alias` to relative file path with given extension

  Examples:

      iex> alias_to_path("Foo.Bar")
      foo/bar.ex
      iex> alias_to_path("Foo.Bar", "bazz")
      foo/bar.bazz
  """
  @spec alias_to_path_part(raw_alias :: String.t(), extension :: String.t()) :: Path.t()
  def alias_to_path_part(raw_alias, extension \\ "ex") do
    Macro.underscore(raw_alias)<>"."<>extension
  end
end
