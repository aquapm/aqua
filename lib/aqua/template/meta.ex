defmodule Aqua.Template.Meta do
  alias Aqua.Jason

  def get_injection(repo_fs, inject_name) do
    case parse_meta(repo_fs) do
      {:ok, %{"injects" => injects}} ->
        case find_inject(injects, inject_name) do
          nil ->
            {:error, :inject_not_found}

          inject ->
            {:ok, inject}
        end

      _error ->
        {:error, :inject_not_found}
    end
  end

  def parse_meta(repo_fs) do
    case File.read(Path.join(repo_fs, "manifest.json")) do
      {:ok, body} ->
        Jason.decode(body)

      error ->
        error
    end
  end

  def find_inject(injects, inject) do
    injects
    |> Enum.find(fn %{"aliases" => aliases, "name" => name} ->
      if name == inject do
        true
      else
        Enum.any?(aliases, fn al -> al == inject end)
      end
    end)
  end

  def get_template(repo_fs) do
    case parse_meta(repo_fs) do
      {:ok, %{"files" => _files, "options" => _options} = template_meta} ->
        {:ok, Map.take(template_meta, ["files", "options"])}

      _error ->
        {:error, :template_corrupted}
    end
  end
end
