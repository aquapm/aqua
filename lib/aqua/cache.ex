defmodule Aqua.Cache do
  alias Aqua.SCM.Git

  @spec aqua_path() :: binary()
  def aqua_path() do
    System.user_home()
    |> Path.join(".aqua")
  end

  @spec config_path() :: binary()
  def config_path() do
    aqua_path()
    |> Path.join("config.json")
  end

  @spec config() :: {:ok, Map.t()}
  def config() do
    with {:ok, raw_config} <- File.read(config_path()),
         {:ok, config} <- Jason.decode(raw_config, keys: :atoms) do
      {:ok, config}
    else
      _ -> {:ok, %{}}
    end
  end

  def official_list() do
    case File.read(official_list_path()) do
      {:error, _} ->
        {:error, :invalid}

      {:ok, data} ->
        {:ok, :erlang.binary_to_term(data)}
    end
  end

  def update_official_list() do
    data = Aqua.Github.list_all_official_templates()
    path = official_list_path()
    File.mkdir(Path.dirname(path))
    File.write(path, :erlang.term_to_binary(data))
    Mix.Shell.IO.info("\n")
    data
  end

  defp official_list_path do
    aqua_path()
    |> Path.join("official_list.term")
  end

  def generate_path(user, repo) do
    Path.join([aqua_path(), user, repo])
  end

  def repo_exists?(user, repo) do
    File.dir?(generate_path(user, repo))
  end

  def sync_repo(url, fs, update?, org, repo) do
    case File.dir?(fs) do
      false ->
        IO.write(
          IO.ANSI.format([
            :cyan,
            "➤  ",
            :bright,
            "Downloading ",
            :normal,
            "template cache: ",
            :magenta,
            "#{org}/#{repo} "
          ])
        )

        case Git.clone_repo(url, fs) do
          {:ok, _} ->
            Mix.Shell.IO.info([:green, "✔  Done"])
            :ok

          {:error, error} ->
            {:error, {:git, error}}
        end

      true ->
        if update? do
          IO.write(
            IO.ANSI.format([
              :cyan,
              "➤  ",
              :bright,
              "Updating ",
              :normal,
              "template cache: ",
              :magenta,
              "#{org}/#{repo} "
            ])
          )

          case Git.pull_repo(fs) do
            {:ok, _} ->
              Mix.Shell.IO.info([:green, "✔  Done"])
              :ok

            {:error, error} ->
              {:error, {:git, error}}
          end
        else
          :ok
        end
    end
  end
end
