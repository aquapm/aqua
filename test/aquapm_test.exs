defmodule AquaTest do
  use ExUnit.Case
  doctest Aqua

  test "greets the world" do
    assert Aqua.hello() == :world
  end
end
