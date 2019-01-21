defmodule Aqua.Options do
  def prepare(args, %{injection_options: opt_list}) do
    {parsed_args, _, _} = OptionParser.parse(args, switches: [], allow_nonexistent_atoms: true)

    %{ok: good_args, error: bad_args} =
      opt_list
      |> Enum.reduce(%{ok: %{}, error: %{}}, fn
        %{"name" => name, "default" => default}, acc ->
          option_name = String.to_atom(name)

          case Keyword.get(parsed_args, option_name) do
            nil -> put_in(acc, [:ok, option_name], default)
            value -> put_in(acc, [:ok, option_name], value)
          end

        %{"name" => name, "required" => true}, acc ->
          arg_name = String.to_atom(name)

          case Keyword.get(parsed_args, arg_name) do
            nil -> put_in(acc, [:error, arg_name], true)
            value -> put_in(acc, [:ok, arg_name], value)
          end
      end)

    case Map.equal?(bad_args, %{}) do
      true -> {:ok, good_args}
      false -> {:error, bad_args}
    end
  end
end
