defmodule AquapmTest do
  use ExUnit.Case
  doctest Aquapm

  test "greets the world" do
    assert Aquapm.hello() == :world
  end
end
