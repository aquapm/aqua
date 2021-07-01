defmodule Empty do
  use Aqua.Template

  def project do
    [
      name: "phx",
      short_description: "Phoenix Framework templates generator",
      vsn: 2,
      accepts: [:standalone, :umbrella],
      elixir_required: "~> 1.9"
    ]
  end

  def switches(context) do
  end

  def template(context) do
    base ++
      if Context.umbrella?() do
        umbrella()
      else
        standalone()
      end
  end

  defp ecto() do

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
