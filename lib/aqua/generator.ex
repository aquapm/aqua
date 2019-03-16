defmodule Aqua.Generator do
  alias Aqua.Views.Generator, as: View

  def generate_template(generate_path, template, assigns) do
    with false <- assigns[:force],
         true <- File.exists?(generate_path),
         false <-
           Aqua.View.safe_yes?([
             :red,
             :bright,
             "⚠ ",
             :normal,
             " Project already exists. Override?"
           ]) do
      {:ok, :success}
    else
      _ ->
        File.rm_rf(generate_path)
        do_generate_template(generate_path, template, assigns)
    end
  end

  defp do_generate_template(generate_path, %{fs_path: template_path} = template, assigns) do
    case get_file_list(template, assigns)
         |> Enum.reduce_while(
           :ok,
           &generate_entity(&2, {&1, template_path, generate_path, assigns})
         ) do
      :ok ->
        {:ok, :success}

      error ->
        File.rm_rf(generate_path)
        error
    end
  end

  # "config/config.exs", "/home/user/.aqua/aquapm/empty"
  @spec in_path(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            ),
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: binary()
  def in_path(path_record, template_path) do
    Path.join([template_path, "template", path_record])
  end

  # "config/config.exs", "/home/user/dev/elixir/my_app"
  def out_path(path_record, generate_path) do
    Path.join(generate_path, path_record)
  end

  def get_file_list(%{template_files_data: file_groups} = _template, assigns) do
    file_groups
    |> Enum.flat_map(fn
      {"base", file_list} ->
        file_list

      {key, file_list} ->
        case Map.get(assigns, String.to_atom(key)) do
          true -> file_list
          _ -> []
        end
    end)
  end

  defp generate_entity(_, {path_record, template_path, generate_path, assigns}) do
    result =
      case Path.extname(path_record) do
        "" -> generate_dir(path_record, template_path, generate_path, assigns)
        _ -> generate_file(path_record, template_path, generate_path, assigns)
      end

    case result do
      {:error, error} -> {:halt, {:error, error}}
      {:ok, _} -> {:cont, :ok}
    end
  end

  defp generate_dir(path_record, _template_path, generate_path, assigns) do
    out_dir_name = evaluate_file_name(path_record, assigns)
    out_dir = out_path(out_dir_name, generate_path)

    case File.mkdir_p(out_dir) do
      :ok -> {:ok, out_dir_name}
      {:error, error} -> {:error, {:gen, error}}
    end
  end

  defp generate_file(path_record, template_path, generate_path, assigns) do
    out_file_name = evaluate_file_name(path_record, assigns)
    in_file = in_path(path_record, template_path)
    out_file = out_path(out_file_name, generate_path)

    try do
      output = EEx.eval_file(in_file, assigns: assigns)

      View.file_inject(Path.relative_to(out_file, File.cwd!()))

      case File.mkdir_p(Path.dirname(out_file)) do
        :ok ->
          case File.write(out_file, output) do
            :ok ->
              View.done()
              {:ok, out_file_name}

            {:error, _error} ->
              {:error, {:gen, :file_create}}
          end

        {:error, _error} ->
          {:error, {:gen, :file_create}}
      end
    rescue
      error ->
        {:error, {:gen, error}}
    end
  end

  defp evaluate_file_name(filename, assigns) do
    # TODO - wrap into :ok tuple
    EEx.eval_string(filename, assigns: assigns)
  end
end
