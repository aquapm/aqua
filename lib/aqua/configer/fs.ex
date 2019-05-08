defmodule Aqua.Configer.Fs do
  @default_config %{}

  @behaviour Aqua.Configer

  alias Aqua.Fs

  def get_config() do
    case File.read(Fs.aqua_config_path()) do
      {:error, :enoent} -> {:error, :not_found}
      {:ok, output} ->
        case Aqua.Jason.decode(output, keys: :atoms) do
          {:ok, config} -> {:ok, config}
          _ -> {:error, :corrupted}
        end
      _ -> {:error, :corrupted}
    end
  end

  @doc """
  Function tries to write default config into a file.

  If success - returns default config
  If failure - returns error
  """
  def default_config() do
    case File.write(Fs.aqua_config_path(), Jason.encode!(@default_config)) do
      :ok -> {:ok, @default_config}
      error -> error
    end
  end
end
