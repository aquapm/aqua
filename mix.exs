defmodule Aqua.MixProject do
  use Mix.Project

  @app :aqua
  @version "0.1.1"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:yaml_elixir, "~> 2.1"}
    ]
  end

  defp aliases() do
    [
      build: [&build_releases/1]
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
