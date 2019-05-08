defmodule Aqua.Tasks.New do
  alias Aqua.Schema.Scaffold
  alias Aqua.Views.New, as: View
  alias Aqua.Tasks.Help

  def run([template | [path | args]]) do
    case %Scaffold{raw: path}
         |> Scaffold.set_project_type()
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
