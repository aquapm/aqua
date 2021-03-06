defmodule Aqua.Views.Add do
  @moduledoc false
  alias Aqua.View

  @spec panic(any()) :: no_return()
  def panic(:not_in_project) do
    View.panic([
      "You are calling ",
      :cyan,
      :bright,
      "mix aqua add ",
      :normal,
      :red,
      "command not inside ",
      :yellow,
      :bright,
      "Mix project folder",
      :normal,
      :red,
      "!\nPlease, ensure that you are in the right filesystem place."
    ])
  end

  def panic(:invalid_path_alias) do
    View.panic([
      "You are calling ",
      :cyan,
      :bright,
      "mix aqua add ",
      :normal,
      :red,
      "followed by invalid ",
      :yellow,
      :bright,
      ":path ",
      :red,
      :normal,
      "or ",
      :yellow,
      :bright,
      ":alias",
      :red,
      :normal,
      "!\nPlease, ensure that you ",
      :bright,
      "didn't skip ",
      :normal,
      "this parameter before calling additional arguments."
    ])
  end

  def panic(:absolute_path) do
    View.panic([
      "Given path is out of the project scope!\nPlease ensure:\n\n",
      View.il([:yellow, "You are not passing absolute path\n"]),
      View.il([:yellow, "Your path is not expanding out of project scope\n"])
    ])
  end

  def panic({:no_sub_app, type, apps}) do
    apps_list =
      apps
      |> Enum.map(fn app_name ->
        View.il([:yellow, "#{inspect(app_name)}\n"])
      end)

    View.panic([
      "For given ",
      :cyan,
      "#{inspect(type)}",
      :red,
      ", umbrella's child application can be found!\n\nAvailable applications are:\n",
      apps_list,
      "\n",
      :normal,
      :red,
      "Please, check your ",
      :cyan,
      "#{inspect(type)}",
      :red,
      " again!"
    ])
  end

  def panic({:git, reason}) do
    View.panic(["Fail!\n", reason])
  end

  def panic(:inject_not_found) do
    View.panic([
      "Given inject is not defined!\nPlease ensure:\n\n",
      View.il([:yellow, "You are calling your inject after right template\n"]),
      View.il([:yellow, "For current template injection, or its alias, exists.\n"])
    ])
  end

  # This is fallback for uncoverd problems
  def panic(problem) do
    View.panic(inspect(problem))
  end
end
