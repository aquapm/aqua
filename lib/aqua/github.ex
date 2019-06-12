defmodule Aqua.Github do
  alias Aqua.Jason
  alias Aqua.Github.Client

  @spec list_all_official_templates() :: [Aqua.Schema.Template.t()]
  def list_all_official_templates() do
    case Client.get_aquapm_repos() do
      {:ok, results} ->
        results
        |> Enum.map(fn %{"name" => name, "url" => url} ->
          %Aqua.Schema.Template{name: name, url: url}
        end)
        |> Aqua.Jobs.ValidateRemoteTemplates.run()
        |> Enum.filter(fn %{valid: valid} -> valid == true end)

      {:error, _} ->
        []
    end
  end

  def validate_template(%Aqua.Schema.Template{url: url, name: name} = template) do
    url =
      String.replace(url, "api.github.com/repos", "raw.githubusercontent.com") <>
        "/master/manifest.json"

    :inets.start()
    :ssl.start()

    case :httpc.request(
           :get,
           {String.to_charlist(url), [{'User-Agent', 'aqua'}]},
           [{:ssl, [{:verify, 0}]}],
           []
         ) do
      {:ok, {_, _, body_char_list}} ->
        case Jason.decode(body_char_list) do
          {:ok, %{"name" => ^name, "short_desc" => desc}} ->
            IO.write(IO.ANSI.format([:green, :bright, "✔ "]))
            %{template | short_desc: desc, valid: true}

          _ ->
            IO.write(IO.ANSI.format([:green, :bright, "✘ "]))
            %{template | valid: false}
        end

      {:error, _} ->
        IO.write(IO.ANSI.format([:green, :bright, "✘ "]))
        %{template | valid: false}
    end
  end

  def generate_clone_url(user, repo) do
    "git@github.com:#{user}/#{repo}.git"
  end

  defp get_aquapm_repos() do
  end
end
