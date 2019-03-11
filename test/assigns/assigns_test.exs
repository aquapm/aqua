defmodule Aqua.Assigns.AssignsTest do
  use ExUnit.Case

  @global_params_list [
    :erlixir_version,
    :erlang_version,
    :otp_release,
    :in_standalone?,
  ]

  describe "global_assigns" do
    test "for valid project name" do
      project_name = "some_good_name"
      in_umbrella = true
      elixir_version = Version.parse!(System.version())
      erlang_version = :erlang.system_info(:version)
      host_os =  Aqua.Assigns.os_type()

      assert %{
        elixir_version: ^elixir_version,
        erlang_version: ^erlang_version,
        host_os: ^host_os,
        project_name: ^project_name
      } = Aqua.Assigns.global_assigns(project_name, in_umbrella)
    end
  end
end
