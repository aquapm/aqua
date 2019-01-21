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
      {os, variant} ->
        "#{os} (#{variant})"

      {os} ->
        "#{os}"

      other ->
        to_string(other)
    end
  end

  def global_assigns(project_name, in_umbrella) do
    %{
      host_os: os_type(),
      now: date_time_values(),
      project_name: project_name,
      project_name_camel_case: Macro.camelize(project_name),
      in_umbrella?: in_umbrella,
      elixir_version: System.version(),
      erlang_version: :erlang.system_info(:version),
      otp_release: :erlang.system_info(:otp_release)
    }
  end
end
