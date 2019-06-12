defmodule Aqua.Tasks.Add do
  @moduledoc false
  alias Aqua.Schema.Inject
  alias Aqua.Views.Add, as: View
  alias Aqua.Tasks.Help

  @doc false
  @spec run(list(String.t())) :: :ok | no_return()
  def run([template | [path | args]]) do
    case %Inject{raw: path}
         |> Inject.set_project_type()
         |> Inject.assert_in_project()
         |> Inject.calculate_pathes()
         |> Inject.load_template(template)
         |> Inject.generate_assigns(args)
         |> Inject.generate() do
      %Inject{valid?: :ok} -> :ok
      %Inject{valid?: {:error, error}} -> View.panic(error)
    end
  end

  def run([]), do: Help.add()
end
