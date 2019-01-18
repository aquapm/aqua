defmodule Aqua.MixProject do
  use Mix.Project

  @app :aqua
  @version "0.1.1"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      aliases: aliases()
      # docs: docs()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  def description() do
    """
    Elixir project management tool.
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:yaml_elixir, "~> 2.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp aliases() do
    [
      build: [&build_releases/1]
    ]
  end

  defp package do
    [
      maintainers: ["Dmitry Rubinstein"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/aquapm/aqua"},
      files: ~w(mix.exs README* CHANGELOG* lib)
    ]
  end

  defp build_releases(_) do
    Mix.env(:prod)
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run(["--output=./#{@app}-archive/#{@app}-#{@version}.ez"])
    File.cp("./#{@app}-archive/#{@app}-#{@version}.ez", "./#{@app}-archive/#{@app}.ez")
  end
end
