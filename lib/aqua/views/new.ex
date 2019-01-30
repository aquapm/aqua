defmodule Aqua.Views.New do
  alias Aqua.View

  def panic({:gen, error}) do
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
end
