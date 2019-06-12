defmodule Aqua.Validators.MinElixirVersion do
  @moduledoc """
  Module validates minimal Elixir version.

  Example:

      # On system with Elixir v 1.8
      iex> validate("~> 1.7")
      {:ok, valid}
      iex> validate("< 1.6")
      {:error, :min_elixir_version}
  """
  @spec validate(requirements :: String.t()) :: {:ok, :valid} | {:error, {:min_elixir_version, String.t()}}
  def validate(requirement) do
    case Version.match?(System.version(), requirement) do
      true -> {:ok, :valid}
      false -> {:error, {:min_elixir_version, requirement}}
    end
  end
end
