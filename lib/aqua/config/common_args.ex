defmodule Aqua.Config.CommonArgs do
  defstruct test: true,
            verbose: false,
            force: false,
            update: false

  @type t :: %__MODULE__{
          test: boolean(),
          verbose: boolean(),
          force: boolean(),
          update: boolean()
        }

  defimpl Collectable do
    def into(original) do
      fun = fn
        map, {:cont, {k, v}} -> %{map | k => v}
        map, :done -> map
        _, :halt -> :ok
      end

      {original, fun}
    end
  end

  @doc """
  Produces `Aqua.Config.CommonArgs` from passed argumrents.

  Arguments that are not presented - skiped
  Arguments to be parse - parsed
  Arguments that are not in the common args list omited
  """
  @spec parse(args_list :: list(String.t())) :: __MODULE__.t()
  def parse(args_list) do
    args_list
    |> OptionParser.parse(
      strict: [test: :boolean, verbose: :boolean, force: :boolean, update: :boolean],
      aliases: [V: :verbose, F: :force, U: :update]
    )
    |> elem(0)
    |> Enum.into(%__MODULE__{})
  end
end
