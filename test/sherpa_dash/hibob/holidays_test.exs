defmodule SherpaDash.Hibob.HolidaysTest do
  import Mock

  use ExUnit.Case
  use ExUnit.Case, async: false

  setup do
    System.put_env("MIN_DAYS_I_WORK", "10")
    System.put_env("MAX_DAYS_I_WORK", "20")
    :ok
  end

  test "#min_max_days_total" do
    [min, max] = SherpaDash.Hibob.Holidays.min_max_days_total(2025)

    assert min == 241
    assert max == 251
  end

  test "#min_max_days_remaining" do
    with_mock SherpaDash.Hibob.Client, number_of_taken_days: fn _year -> 10 end do
      [min, max] = SherpaDash.Hibob.Holidays.min_max_days_remaining(2025)

      assert min == 241 - 10
      assert max == 251 - 10
    end
  end
end
