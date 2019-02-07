defmodule Aqua.Tasks.Update do
  alias Aqua.Cache

  alias Aqua.Schema.LocalTemplate
  alias Aqua.Views.Update, as: View

  @moduledoc """
  * `mix aqua update` - updating predefined repository list cache
  * `mix aqua update otp` - updateing `aquapm/otp`
  * `mix aqua update phoenix/phx` - updating `phoenix/phx`
  """

  def run([]) do
    Cache.update_official_list()
    Mix.Shell.IO.info([:green, "✔  Done", :normal, :cyan, "\nPredefined templates list updated"])
  end

  def run([template | _args]) do
    case %LocalTemplate{raw_route: template, git_update?: true}
    |> LocalTemplate.normalize_route()
    |> LocalTemplate.sync_repo() do
      %LocalTemplate{valid?: {:error, error}} -> View.panic(error)
      _ -> :ok
    end
  end
end
