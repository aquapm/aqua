defmodule Aqua.Jobs.ValidateRemoteTemplates do
  alias Aqua.Schema.Template
  alias Aqua.Github

  @spec run(template_list :: list(Template.t())) :: list(Template.t())
  def run(template_list) do
    Task.async_stream(template_list, &Github.validate_template/1)
    |> Enum.map(fn {:ok, template}-> template end)
  end
end
