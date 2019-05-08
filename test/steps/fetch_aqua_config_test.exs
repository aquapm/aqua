defmodule Aqua.Steps.SetProjectTypeTest do
  use ExUnit.Case
  alias Aqua.Steps.SetProjectType

  describe "SetProjectType protocol" do
    test "Bypass with error" do
      expected = %{valid?: {:error, :fail}}
      actual = %{valid?: {:error, :fail}}
      |> SetProjectType.perform()

      assert expected == actual
    end
  end
end
