defmodule Empty do
  use Aqua.Template

  def project do
    [
      name: "empty",
      short_description: "Empty project",
      vsn: 2,
      accepts: [:standalone, :umbrella],
      elixir_required: "~> 1.9"
    ]
  end

  def template(context) do
    base ++
      if Context.umbrella?() do
        umbrella()
      else
        standalone()
      end
  end

  def base() do
    [
      "config/config.exs",
      ".formatter.exs",
      "mix.exs",
      "README.md",
      "lib"
    ]
  end

  def umbrella() do
    []
  end

  def standalone() do
    [{".gitignore.template", ".gitignore"}]
  end
end

defmodule Empty.Docker do
  # use Aqua.Template.Boot
  use Empty, :inject
end

defmodule Empty.File do
  use Empty, :boot
end
