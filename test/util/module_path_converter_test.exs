defmodule Aqua.Util.ModulePathConverterTest do
  use ExUnit.Case, async: true

  alias Aqua.XDG, as: Subj

  test "data_home is defined" do
    left = Path.join([System.user_home, ".local", "share"])
    assert ^left = Subj.data_home()
  end

  test "config_home is defined" do
    left = Path.join([System.user_home, ".config"])
    assert ^left = Subj.config_home()
  end

  test "cache_home is defined" do
    left = Path.join([System.user_home, ".cache"])
    assert ^left = Subj.cache_home()
  end
end
