defmodule Aqua.Templates.V1.Structure do
  @moduledoc """
  Represents template configuration structure
  """

  defstruct [
    version: :strict,
    name: :strict,
    short_desc: :strict,
    options: [],
    files: :strict,
    injects: []
  ]

  defmodule Inject do
    @moduledoc """
    Represents template's inject configuration structure
    """

    defstruct [
       name: :strict,
       description: :strict,
       aliases: [],
       template: :strict,
       options: []
    ]
  end
end
