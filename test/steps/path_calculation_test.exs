defmodule Aqua.Steps.PathCalculationTest do
  use ExUnit.Case
  alias Aqua.Steps.PathCalculation

  describe "With incoming error" do
    test "Byepass the error" do
      bad_struct = %{valid?: {:error, false}}

      assert ^bad_struct = PathCalculation.perform(bad_struct)
    end
  end

  describe "For new application" do
    setup do
      [input: %{raw: "good_project_name", project_type: :none}]
    end

    test "Calculates valid pathes", %{input: input} do
      results = PathCalculation.perform(input)
    end
  end
end
