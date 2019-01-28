defmodule Aqua.Tasks.New do
  alias Aqua.Schema.Scaffold
  alias Aqua.Views.New, as: View
  alias Aqua.Tasks.Help

  # @doc false
  # @spec run(list(String.t())) :: :ok | no_return()
  # def run([template | [path | args]]) do
  #   case %Scaffold{project_name: path}
  #        |> Inject.set_project_type()
  #        |> Inject.assert_in_project()
  #        |> Inject.calculate_pathes()
  #        |> Inject.load_template(template)
  #        |> Inject.generate_assigns(args)
  #        |> Inject.generate() do
  #     %Inject{valid?: :ok} -> :ok
  #     %Inject{valid?: {:error, error}} -> View.panic(error)
  #   end
  # end

  def run([template | [name | args]]) do
    case %Scaffold{raw: name}
         |> Scaffold.set_project_type()
         |> Scaffold.assert_not_in_flat_project()
         # For umbrella - will inject inside apps folder.
         |> Scaffold.calculate_pathes()
         |> IO.inspect()
        #  |> Scaffold.load_template(template)
        #  # will panic if the project is only under umbrella but inserted as flat and vice verse
        #  |> Scaffold.assert_inject_type()
        #  |> Scaffold.generate_assigns(args)
        #  |> Scaffold.generate()
    do
      %Scaffold{valid?: :ok} -> :ok
      %Scaffold{valid?: {:error, error}} -> View.panic(error)
    end
  end

  def run() do
  end

  def run([]), do: Help.welcome(:new)
end
