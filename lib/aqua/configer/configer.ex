defmodule Aqua.Configer do
  @callback get_config() :: {:ok, Map.t()} | {:error, :corrupted} | {:error, :not_found}
  @callback default_config() :: {:ok, Map.t()} | {:error, any()}
end
