defmodule Aqua.Views.List do
  alias Aqua.View

  def panic({:gen, _error}) do
    # TODO: Use arror with needed verbosity
    View.panic([
      "Fail!\nGenerator faced error during project genration process.\nPlease, ensure:\n\n",
      View.il([:yellow, "Template is not corrupted;\n"]),
      View.il([:yellow, "Your future project's location in filesystem is not corruped;\n"])
    ])
  end

  def panic(:bad_project_name) do
    View.panic([
      "Fail! mix aqua new accepts only one-level project names!\nEnsure your project name is valid"
    ])
  end

  def panic(:template_corrupted) do
    View.panic([
      "Fail! Template seems to be corrupted!\nPlease, ensure\n\n",
      View.il([:yellow, "You are using Aqua's template;\n"]),
      View.il([:yellow, "Aqua's and Template's versions are matching and are not too old;\n"])
    ])
  end

  def panic({:git, reason}) do
    View.panic(["Fail!\n", reason])
  end
end
