defmodule Aqua.Schema.AquaPMTemplateList do
  alias Aqua.Constants
  alias Aqua.XDG

  @moduledoc """

  """

  defstruct data: nil

  @type t :: %__MODULE__{}

  def path do
    XDG.cache_home()
    |> Path.join(Constants.aqua_folder())
    |> Path.join(Constants.aquapm_templates_list_filename())
  end

  @doc """
  Function tries to read data structure from it's place in file system.
  It will also validate type of a data inside the cache file.
  """
  @spec fs_read() :: {:ok, t()} | {:error, :bad_file | :bad_data}
  def fs_read() do
    case File.read(path()) do
      {:ok, raw_data} -> parse_template_list_data(raw_data)
      _error -> {:error, :bad_file}
    end
  end

  @spec parse_template_list_data(raw_data :: binary()) :: {:ok, any()}
  defp parse_template_list_data(raw_data) do
    case :erlang.binary_to_term(raw_data) do
      %__MODULE__{} = data -> {:ok, data}
      _ -> {:error, :bad_data}
    end
  rescue
    _ -> {:error, :bad_data}
  end

  @spec encode_template_data(template_list :: t()) ::
          {:ok, binary()} | {:error, :bad_encoding_type}
  defp encode_template_data(%__MODULE__{} = template_list) do
    {:ok, :erlang.term_to_binary(template_list)}
  end

  defp encode_template_data(_) do
    {:error, :bad_encode_type}
  end
end
