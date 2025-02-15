defmodule SherpaDash.Hibob.ClientTest do
  use ExUnit.Case

  test "#get_time_off" do
    time_off = SherpaDash.Hibob.Client.get_time_off()

    assert time_off == 7
  end
end
