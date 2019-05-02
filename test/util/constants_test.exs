defmodule Aqua.Util.ConstantsTest do
  use ExUnit.Case, async: true

  alias Aqua.Constants, as: Subj

  test "aqua folder is defined" do
    assert "aqua" = Subj.aqua_folder()
  end

  test "config filename is defined" do
    assert "config.json" = Subj.config_filename()
  end
end
