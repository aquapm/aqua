defmodule Aqua.Tasks.New do
  alias Aqua.Schema.Scaffold
  alias Aqua.Views.New, as: View
  alias Aqua.Tasks.Help

  alias Aqua.Steps
  alias Aqua.Validators

  def run([template | [path | args]]) do
    case %Scaffold{raw: path}
         |> Steps.SetProjectType.perform()
         |> Scaffold.assert_not_in_flat_project()
         |> Scaffold.calculate_pathes()
         |> Scaffold.load_template(template)
         |> Scaffold.generate_assigns(args)
         |> Scaffold.generate() do
      %Scaffold{valid?: :ok} -> :ok
      %Scaffold{valid?: {:error, error}} -> View.panic(error)
    end
  end

  def run(_), do: Help.new()
end
