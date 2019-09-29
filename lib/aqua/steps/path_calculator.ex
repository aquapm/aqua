defprotocol Aqua.Steps.PathCalculation do
  @fallback_to_any true

  def perform(state)
end

defimpl Aqua.Steps.PathCalculation, for: Any do
  def perform(%{valid?: {:error, _}} = state), do: state
  def perform(%{raw: raw_path, project_type: project_type} = state) do

  end
end
