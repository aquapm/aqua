defmodule Aqua.Github do
  alias Aqua.Schema.LocalRepo

  def list_all_official_templates() do
    :inets.start()
    :ssl.start()

    case :httpc.request(
           :get,
           {'https://api.github.com/orgs/aquapm/repos', [{'User-Agent', 'aqua'}]},
           [{:ssl, [{:verify, 0}]}],
           []
         ) do
      {:ok, {_, _, body_char_list}} ->
        Jason.decode!(body_char_list)
        |> Enum.map(fn %{"name" => name, "url" => url} ->
          %Aqua.Schema.Template{name: name, url: url}
        end)
        |> Enum.map(&validate_template/1)
        |> Enum.filter(fn %{valid: valid} -> valid == true end)

      {:error, _} ->
        []
    end
  end

  def validate_template(%Aqua.Schema.Template{url: url, name: name} = template) do
    url =
      String.replace(url, "api.github.com/repos", "raw.githubusercontent.com") <>
        "/master/manifest.yml"

    case :httpc.request(
           :get,
           {String.to_charlist(url), [{'User-Agent', 'aqua'}]},
           [{:ssl, [{:verify, 0}]}],
           []
         ) do
      {:ok, {_, _, body_char_list}} ->
        case YamlElixir.read_from_string(body_char_list) do
          {:ok, %{"name" => ^name, "short_desc" => desc}} ->
            %{template | short_desc: desc, valid: true}

          _ ->
            %{template | valid: false}
        end

      {:error, _} ->
        %{template | valid: false}
    end
  end

  def generate_clone_url(user, repo) do
    "git@github.com:#{user}/#{repo}.git"
  end

end
