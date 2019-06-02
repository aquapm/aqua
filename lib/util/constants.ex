defmodule Aqua.Constants do
  @doc """
  Returns Aqua's folder name.
  Used for file-system operations, connected with XDG pathes
  """
  @spec aqua_folder() :: String.t()
  def aqua_folder do
    "aqua"
  end


  @doc """
  Returns Aqua's config filename
  """
  @spec config_filename() :: String.t()
  def config_filename do
    ".aquaconfig"
  end


  @doc """
  Returns filename for AquaPM templates list.
  """
  @spec aquapm_templates_list_filename() :: String.t()
  def aquapm_templates_list_filename do
    "aquapm_templates.list"
  end
end
