defmodule Aqua.Github.Client do
  alias Aqua.Jason

  @spec get_aquapm_repos() :: {:error, :github_error | Aqua.Jason.DecodeError.t()} | {:ok, any()}
  def get_aquapm_repos() do
    init_client()

    case :httpc.request(
           :get,
           {'https://api.github.com/orgs/aquapm/repos', [{'User-Agent', 'aqua'}]},
           [{:ssl, [{:verify, 0}]}],
           []
         ) do
      {:ok, {_, _, body_char_list}} -> Jason.decode(body_char_list)
      {:error, _} -> {:error, :github_error}
    end
  end

  def get_raw_file(url) do

  end

  @spec init_client() :: :ok
  defp init_client() do
    :inets.start()
    :ssl.start()
    :ok
  end
end
