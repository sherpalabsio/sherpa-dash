defmodule SherpaDash.Hibob.ClientTest do
  use ExUnit.Case

  test "#number_of_taken_days" do
    time_off = SherpaDash.Hibob.Client.number_of_taken_days()

    assert time_off == 7
  end
end
