defmodule Aqua.Validators.MinElixirVersionTest do
  use ExUnit.Case
  alias Aqua.Validators.MinElixirVersion

  describe "validate" do
    test "Returns valid for valid requirements" do
      assert {:ok, :valid} = MinElixirVersion.validate(">= #{System.version()}")
    end

    test "Returns fail for invalid requirements" do
      requirements = "<= 0.9.0"
      assert {:error, {:min_elixir_version, ^requirements}} = MinElixirVersion.validate(requirements)
    end
  end
end
