defmodule Aqua.ConfigStore do
  alias Aqua.Views.ConfigStore, as: View

  @default_args [
    %{"name" => "test", "default" => true, "type" => "boolean"},
    %{"name" => "verbose", "aliases"=> ["v"], "default" => false, "type" => "boolean"},
    %{"name" => "force", "aliases" => ["f"], "default" => false, "type" => "boolean"},
    %{"name" => "update", "default" => false, "type" => "boolean"},
  ]

  @op_args Aqua.Options.populate_strict(@default_args)

  use GenServer
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: Aqua.ConfigStore)
  end

  def init(args) do
    case Keyword.get(args, :query_string) do
      query_string when is_binary(query_string) ->
        case parse_common_args(query_string) do
          {:ok, commons} -> {:ok, Map.merge(@defaults, commons), {:continue, :load_config}}
          {:error, reason} -> View.panic({:init, reason})
        end
      _ -> {:ok, @defaults, {:continue, :load_config}}
    end
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
