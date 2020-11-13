defmodule Aqua.XDG do
  @data [
    data_home: Path.join([System.user_home(), ".local", "share"]),
    config_home: Path.join([System.user_home(), ".config"]),
    cache_home: Path.join([System.user_home(), ".cache"])
  ]

  for {name, path} <- @data do
    @spec unquote(name)() :: Path.t()
    def unquote(name)() do
      System.get_env(unquote(String.upcase("xdg_#{name}"))) || unquote(path)
    end
  end
end
