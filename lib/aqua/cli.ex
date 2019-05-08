defmodule Aqua.Cli do
  def loop() do
    command = "> "
    |> IO.gets()
    |> String.split()

    if "exit" == hd(command) do
      System.halt()
    end

    # {command_exec, _} = System.cmd("which", [hd(command)])
    # command_exec = command_exec |> String.trim()


    {:ok, command_exec} = which("mix")

    port =
      :erlang.open_port({:spawn_executable, command_exec}, [
        {:args, ["aqua" | command]},
        :exit_status,
        :nouse_stdio
      ])

    receive do
      {^port, {:exit_status, _}} ->
        loop()
    end
  end

  @doc """
  Function tries to find executable by its name or path:

  * **success** - returns absolute path.

  * **fail** - returns `:not_found`.

  ### Examples

      iex> Aqua.Cli.which("ls")
      {:ok, "/bin/ls"}

      iex> Aqua.Cli.which("mix")
      {:ok, "/users/aqua/.asdf/shims/mix"}

      iex> Aqua.Cli.which("keks")
      {:error, :not_found}
  """
  @spec which(executable :: String.t()) :: {:ok, absolute_path :: String.t} | {:error, :not_found}
  def which(executable) do
    case :os.type() do
      {:unix, _} ->
        Aqua.Cli.Unix.which(executable)
      {:win32, _} ->
        Aqua.Cli.Win.which(executable)
    end
  end
end
