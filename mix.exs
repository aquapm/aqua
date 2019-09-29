defmodule Aqua.MixProject do
  use Mix.Project

  @app :aqua
  @version "1.0.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      aliases: aliases(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mox, "~> 0.5.0", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end

  defp aliases() do
    [
      build: [&build_releases/1],
      reinstall: ["build", &reinstall_archive/1],
      uninstall: [&uninstall_archive/1]
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

  defp docs do
    [
      main: "readme",
      logo: "extras/logo.png",
      extras: [
        "README.md",
        "extras/Template Creation.md",
        "extras/Template Injections.md"
      ]
    ]
  end

  defp build_releases(_) do
    Mix.env(:prod)
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run(["--output=./#{@app}-archive/#{@app}-#{@version}.ez"])
    File.cp("./#{@app}-archive/#{@app}-#{@version}.ez", "./#{@app}-archive/#{@app}.ez")
  end

  def uninstall_archive(_) do
    Mix.Tasks.Archive.Uninstall.run(["aqua-#{@version}", "--force"])
  end

  defp reinstall_archive(_) do
    Mix.Tasks.Archive.Install.run(["aqua-archive/aqua.ez", "--force"])
  end
end
