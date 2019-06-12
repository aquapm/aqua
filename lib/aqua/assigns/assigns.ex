defmodule Aqua.Assigns do
  def date_time_values do
    {local_date_e, local_time_e} = :calendar.local_time()
    local_time = local_time_e |> Time.from_erl!() |> Time.to_string()
    local_date = local_date_e |> Date.from_erl!() |> Date.to_string()

    utc = DateTime.utc_now()

    %{
      utc: %{
        time: utc |> DateTime.to_time() |> Time.to_string(),
        date: utc |> DateTime.to_date() |> Date.to_string(),
        date_time: DateTime.to_iso8601(utc)
      },
      local: %{
        time: local_time,
        date: local_date,
        date_time: "#{local_date} #{local_time}"
      }
    }
  end

  def os_type do
    case :os.type() do
      {os, variant} -> "#{os} (#{variant})"
    end
  end

  @spec global_assigns(project_name :: String.t(), in_umbrella? :: boolean()) :: Map.t()
  @doc """
  Generates basic assigns, including:

  * Host OS
  * Date and Time
  * Elixir and Erlang / OTP versions
  * If the generating is inside umbrella
  """
  def global_assigns(project_name, in_umbrella?) do
    %{
      host_os: os_type(),
      now: date_time_values(),
      project_name: project_name,
      project_name_camel_case: Macro.camelize(project_name),
      in_umbrella?: in_umbrella?,
      in_standalone?: not in_umbrella?,
      elixir_version: Version.parse!(System.version()),
      erlang_version: :erlang.system_info(:version),
      otp_release: :erlang.system_info(:otp_release)
    }
  end
end
