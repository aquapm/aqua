defmodule Aqua.Tasks.New do
  alias Aqua.Schema.Scaffold
  alias Aqua.Views.New, as: View
  alias Aqua.Tasks.Help

  alias Aqua.Steps
  alias Aqua.Validators

  def run([template | [path | args]]) do
    case %Scaffold{raw: path}
         |> Steps.SetProjectType.perform()
         |> Validators.InProjectOfType.perform([:umbrella, :none])
         |> Steps.PathCalculator.perform()
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
