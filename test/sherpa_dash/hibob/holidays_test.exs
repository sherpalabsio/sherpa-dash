defmodule SherpaDash.Hibob.HolidaysTest do
  use ExUnit.Case

  setup do
    System.put_env("MIN_DAYS_I_WORK", "10")
    System.put_env("MAX_DAYS_I_WORK", "20")
    :ok
  end

  test "#min_max_days" do
    [min, max] = SherpaDash.Hibob.Holidays.min_max_days(2025)

    assert min == 241
    assert max == 251
  end
end
