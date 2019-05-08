defprotocol Aqua.Steps.DepsGet do
  def perform(state)
end

defimpl Aqua.Steps.DepsGet, for: Any do
  def perform(%{valid?: {:error, _}} = state), do: state

  def perform(%{deps_get?: true, project_root: }) do

  end
end
