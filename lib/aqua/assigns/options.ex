defmodule Aqua.Options do
  @default_args [
    %{"name" => "test", "default" => true, "type" => "boolean"},
    %{"name" => "force", "aliases" => ["f"], "default" => false, "type" => "boolean"}
  ]

  defp with_defaults(arg_options) do
    @default_args ++ arg_options
  end

  @doc """
  Function will create OptionParser configuration based on config from Json configuration.

  Option parser here:
  [strict: [name: :type, ...], aliases: [t: test, ...], key1: :value1]
  """
  def populate_strict(injection_options) do
    injection_options
    |> with_defaults()
    |> Enum.reduce([strict: [], aliases: []], fn %{"name" => name, "type" => type} = option,
                                                 acc ->
      option_name = String.to_atom(name)
      option_type = String.to_atom(type)

      acc
      |> inject_strict(option_name, option_type)
      |> inject_aliases(option_name, Map.get(option, "aliases", []))
    end)
  end

  defp inject_strict(option_parser_options, name, type) do
    put_in(option_parser_options, [:strict, name], type)
  end

  defp inject_aliases(option_parser_options, full_name, aliases) do
    Enum.reduce(aliases, option_parser_options, fn alias_string, acc ->
      put_in(acc, [:aliases, String.to_atom(alias_string)], full_name)
    end)
  end

  @doc """
  * parsed_options_keyword - keyword with OptionParsers.parser results
  * injection_options - options that we want to validate
  """
  def validate_required_opts(parsed_options_keyword, injection_options) do
    result_options =
      injection_options
      |> with_defaults()
      |> Enum.map(fn
        %{"name" => name, "required" => true} ->
          option_name = String.to_atom(name)

          case Keyword.has_key?(parsed_options_keyword, option_name) do
            false -> {:error, {option_name, :required}}
            true -> {:ok, {option_name, Keyword.get(parsed_options_keyword, option_name)}}
          end

        %{"name" => name, "default" => default, "type" => type} ->
          option_name = String.to_atom(name)

          case Keyword.has_key?(parsed_options_keyword, option_name) do
            false -> {:ok, {option_name, convert_value(default, type)}}
            true -> {:ok, {option_name, Keyword.get(parsed_options_keyword, option_name)}}
          end
      end)

    case Keyword.get_values(result_options, :error) do
      [] -> {:ok, Keyword.get_values(result_options, :ok)}
      errors_list -> {:error, errors_list}
    end
  end

  defp convert_value(value, type) when is_binary(value) and type in ["integer", :integer] do
    case Integer.parse(value) do
      {value, _} -> value
      :error -> raise ArgumentError
    end
  end

  defp convert_value(value, type) when is_integer(value) and type in ["integer", :integer] do
    value
  end

  defp convert_value(value, type) when is_binary(value) and type in ["boolean", :boolean] do
    case value do
      "true" -> true
      "false" -> false
      _ -> raise ArgumentError
    end
  end

  defp convert_value(value, type) when is_atom(value) and type in ["boolean", :boolean] do
    case value do
      true -> true
      false -> false
      _ -> raise ArgumentError
    end
  end

  defp convert_value(value, type) when is_binary(value) and type in ["string", :string], do: value
end
