defprotocol Aqua.Steps.SetProjectType do
  @moduledoc """
  Sets a type of a project.

  Available types:

  * :flat
  * :umbrella
  * :none
  """
  @fallback_to_any true

  def perform(state)
end

defimpl Aqua.Steps.SetProjectType, for: Any do
  def perform(%{valid?: {:error, _}} = state), do: state
  def perform(state) do
    case Mix.Project.umbrella?() do
      false ->
        case Mix.Project.get() do
          nil -> Map.put(state, :project_type, :none)
          _ -> Map.put(state, :project_type, :flat)
        end

      true ->
        Map.put(state, :project_type, :umbrella)
    end
  end
end
