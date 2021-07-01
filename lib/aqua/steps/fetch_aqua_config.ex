defmodule Aqua.Steps.FetchAquaConfig do
  @moduledoc """
  First step: config is fetched. If it's not presented - default config is created
  """

  alias Aqua.Fs

  @default_config %{
    update_always: false,
    color: true
  }

  def perform(context) do
    case get_config() do
      {:ok, config} ->
        Map.put(context, :aqua_config, config)

      {:error, :corrupted} ->
        Map.put(context, :valid?, {:error, {:aqua_config, :corrupted}})

      {:error, :not_found} ->
        case default_config() do
          {:ok, config} -> Map.put(context, :aqua_config, config)
          {:error, reason} -> Map.put(context, :valid?, {:error, {:aqua_config, reason}})
        end
    end
  end

  @spec get_config :: {:error, :corrupted | :not_found} | {:ok, any}
  def get_config() do
    case File.read(Fs.local_config_path()) do
      {:error, :enoent} ->
        {:error, :not_found}

      {:ok, output} ->
        case Jason.decode(output, keys: :atoms) do
          {:ok, config} -> {:ok, config}
          _ -> {:error, :corrupted}
        end

      _ ->
        {:error, :corrupted}
    end
  end

  @doc """
  Function tries to write default config into a file.

  If success - returns default config
  If failure - returns error
  """
  def default_config() do
    case File.write(Fs.local_config_path(), Jason.encode!(@default_config, pretty: true)) do
      :ok -> {:ok, @default_config}
      error -> error
    end
  end
end
