defmodule Aqua.Config.CommonArgs do
  @moduledoc false
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
