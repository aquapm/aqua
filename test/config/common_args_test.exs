defmodule Aqua.Config.CommonArgsTest do
  use ExUnit.Case
  alias Aqua.Config.CommonArgs

  describe "CommonArgs structure" do
    test "Empty structure has valid defaults" do
      assert %CommonArgs{test: true, verbose: false, force: false, update: false} == %CommonArgs{}
    end
  end

  describe "CommonArgs Collectable protocol" do
    test "Successfully adopts valid values" do
      assert %CommonArgs{test: false, verbose: true, force: true, update: true} == Enum.into([test: false, verbose: true, force: true, update: true], %CommonArgs{})
    end

    test "Fails with invalid params" do
      assert_raise KeyError, fn ->
        Enum.into([bad_value: true], %CommonArgs{})
      end
    end

    test "Adopts empty enumerbale with default values" do
      assert %CommonArgs{test: true, verbose: false, force: false, update: false} == Enum.into([], %CommonArgs{})
    end
  end

  describe "CommonArgs :: parse" do
    test "It parses empty args to default structure" do
      assert %CommonArgs{} == CommonArgs.parse([])
    end

    test "it accepts valid params" do
      assert %CommonArgs{test: false, verbose: true, force: true, update: true} == CommonArgs.parse(["--no-test", "--verbose", "--force", "--update"])
    end

    test "it skips invalid params" do
      assert %CommonArgs{test: false, verbose: true, force: true, update: true} == CommonArgs.parse(["--no-test", "--verbose", "--force", "--update", "--bad-params"])
    end

    test "it accepts aliases" do
      assert %CommonArgs{test: false, verbose: true, force: true, update: true} == CommonArgs.parse(["--no-test", "-V", "-F", "-U"])
    end
  end
end
