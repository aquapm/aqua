defmodule Aqua.Tasks.Add do
  alias Aqua.Schema.Inject
  alias Aqua.Views.Add, as: View
  alias Aqua.Tasks.Help

  def run([template | [path | args]]) do
    %Inject{raw: path}
    |> Inject.set_project_type()
    |> Inject.assert_in_project()
    |> assert_valid()
    |> Inject.calculate_pathes()
    |> assert_valid()
    |> Inject.load_template(template)
    |> assert_valid()
    |> Inject.generate_assigns(args)
    |> assert_valid()
    |> IO.inspect()
    # # |> Inject.inject()
    # |> assert_valid()
  end

  def run([]), do: Help.add()

  defp assert_valid(%Inject{valid?: :ok} = inject), do: inject

  defp assert_valid(%Inject{valid?: {:error, type}}) do
    View.panic(type)
  end
end
