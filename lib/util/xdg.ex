defmodule Aqua.XDG do
  @data [
    data_home: Path.join([System.user_home, ".local", "share"]),
    config_home: Path.join([System.user_home, ".config"]),
    cache_home: Path.join([System.user_home, ".cache"])
  ]

  for {name, path} <- @data do
    def unquote(name)() do
      System.get_env(String.upcase("xdg_#{unquote(name)}")) || unquote(path)
    end
  end
end
