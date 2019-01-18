defmodule Aqua.Tasks.New do
  alias Aqua.Tasks.Help
  alias Aqua.Templates
  alias Aqua.Bootstraper

  def run([]), do: Help.new()

  def run([route | args]) do
    case Templates.get(route) do
      {:ok, path_to_template} ->
        Bootstraper.generate(path_to_template, args)
      {:error, :invalid_route} -> Mix.Shell.IO.error("Template name #{route} is invalid. Does this template exist?")
      {:error, reason} -> Mix.Shell.IO.error("Template cache retrieving failed: #{reason}")
    end
  end

  def run(args) do
    IO.inspect OptionParser.parse(args, switches: [test: :boolean], allow_nonexistent_atoms: true)
    IO.inspect args
  end
end
