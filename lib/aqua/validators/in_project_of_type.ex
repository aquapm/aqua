defprotocol Aqua.Validators.InProjectOfType do
  @moduledoc """
  Validates that the current running Mix project has valid type by the given template.

  Available types are:
  * :flat
  * :umbrella
  """

  def perform(state, accepted_types_list)
end

defimpl Aqua.Validators.InProjectOfType, for: Any do
  def perform(%{valid?: {:error, _}} = state, _), do: state
  def perform(%{project_type: project_type} = state, accepted_types_list) do
    if project_type in accepted_types_list do
      state
    else
      Map.put(state, :valid?, {:error, {:bad_project_type, project_type, accepted_types_list}})
    end
  end
end
