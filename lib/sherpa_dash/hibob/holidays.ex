defmodule SherpaDash.Hibob.Holidays do
  def data_for(year) do
    [min_total, max_total] = min_max_days_total(year)

    days_taken = SherpaDash.Hibob.Client.number_of_taken_days(year)

    %{
      min: %{
        taken: days_taken,
        remaining: min_total - days_taken,
        total: min_total
      },
      max: %{
        taken: days_taken,
        remaining: max_total - days_taken,
        total: max_total
      }
    }
  end

  def min_max_days_total(year) do
    first_day_of_the_year = Date.new!(year, 1, 1)
    last_day_of_the_year = Date.new!(year, 12, 31)

    number_of_working_days =
      Enum.count(Date.range(first_day_of_the_year, last_day_of_the_year), fn date ->
        Date.day_of_week(date) in 1..5
      end)

    min_days_i_work = String.to_integer(System.get_env("MIN_DAYS_I_WORK"))
    max_days_i_work = String.to_integer(System.get_env("MAX_DAYS_I_WORK"))

    [number_of_working_days - max_days_i_work, number_of_working_days - min_days_i_work]
  end
end
