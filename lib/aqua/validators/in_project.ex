defprotocol Aqua.Validators.InProject do
  @moduledoc """
  Validate that the command is running inside Mix project folder
  """

  def perform(state)
end

defimpl Aqua.Validators.InProject, for: Any do
  def perform(%{valid?: {:error, _}} = state), do: state
  def perform(%{project_type: :none} = state), do: Map.put(state, :valid?, {:error, :not_in_project})
  def perform(%{project_type: _} = state), do: state
end
