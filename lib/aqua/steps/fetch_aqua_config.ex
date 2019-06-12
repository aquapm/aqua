defprotocol Aqua.Steps.FetchAquaConfig do
  @moduledoc """
  Loads Aqua local configuration into given structure
  """

  def perform(state, configer)
end

defimpl Aqua.Steps.FetchAquaConfig, for: Any do
  def perform(%{valid?: {:error, _}} = state, _), do: state
  def perform(state, configer) do
    case configer.get_config() do
      {:ok, config} -> Map.put(state, :aqua_config, config)
      {:error, :corrupted} -> Map.put(state, :valid?, {:error, :aqua_config_corrupted})
      {:error, :not_found} ->
        case configer.default_config() do
          {:ok, config} -> Map.put(state, :aqua_config, config)
          {:error, reason} -> Map.put(state, :valid?, {:error, {:aqua_config, reason}})
        end
    end
  end
end
