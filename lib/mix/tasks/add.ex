defmodule Aqua.Tasks.Add do
  alias Aqua.ProjectParser

  def project_name() do
    case File.read("mix.exs") do
      {:ok, data} ->
        case ProjectParser.parse_project(data) do
          {:ok, project_data} ->
            IO.inspect(Keyword.get(project_data, :app))

          {:error, :bad_project} ->
            Mix.Shell.IO.error([
              :red,
              :bright,
              "✘ ",
              :yellow,
              "mix.exs ",
              :red,
              "file doesn't export module with ",
              :green,
              "Mix.Project",
              :red,
              "behaviour.\nTry to check it out!"
            ])

          {:error, :mix_corrupted} ->
            Mix.Shell.IO.error([
              :red,
              :bright,
              "✘ ",
              :yellow,
              "mix.exs ",
              :red,
              "file is corrupted and cant be compiled!\nTry to fix compilation errors inside your project's ",
              :yellow,
              "mix.exs"
            ])
        end

      {:error, _} ->
        Mix.Shell.IO.error([
          :red,
          :bright,
          "✘ ",
          :yellow,
          "mix.exs ",
          :red,
          "file is not found!\nYou should run ",
          :cyan,
          "aqua new ",
          :red,
          "inside your project's folder!"
        ])
    end
  end


end
