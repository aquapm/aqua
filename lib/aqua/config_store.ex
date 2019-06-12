defmodule Aqua.ConfigStore do
  @moduledoc """

  Args (Keyword):

  * `args_list` - args list to be parsed as params for running `mix aqua` instance
  """

  alias Aqua.Views.ConfigStore, as: View
  alias Aqua.Config.CommonArgs

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: Aqua.ConfigStore)
  end

  def init(args) do
    {
      :ok,
      %{
        common_args: CommonArgs.parse(Keyword.get(args, :args_list, []))
      },
      {:continue, :load_config}
    }
  end

  def handle_continue(:load_config, state) do
    case Aqua.Cache.config() do
      {:ok, config} -> {:noreply, Map.merge(state, config)}
    end
  end

  defp parse_common_args(query_string) do
    :not_implemented
  end
end
