defmodule SherpaDash.Hibob.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.hibob.com/v1"

  plug Tesla.Middleware.Headers, [
    {"accept", "application/json"},
    {"Authorization", "Basic " <> System.get_env("HIBOB_TOKEN")}
  ]

  plug Tesla.Middleware.JSON

  def number_of_taken_days do
    current_year = DateTime.utc_now().year
    number_of_taken_days(current_year)
  end

  def number_of_taken_days(year) do
    start_date = "#{year}-01-01"
    end_date = "#{year}-12-31"

    {:ok, response} =
      get("/timeoff/whosout",
        query: [
          from: start_date,
          to: end_date
        ]
      )

    unless response.status in 200..299 do
      raise SherpaDash.Hibob.RequestError, status: response.status
    end

    response.body["outs"]
    |> Enum.filter(fn out ->
      out["employeeId"] == System.get_env("HIBOB_EMPLOYEE_ID") &&
        out["policyTypeDisplayName"] == "Absence"
    end)
    |> Enum.reduce(0, fn out, acc ->
      acc + work_days_between(year, out["startDate"], out["endDate"])
    end)
  end

  def work_days_between(year, start_date, end_date) do
    {:ok, start_date} = Date.from_iso8601(start_date)
    {:ok, end_date} = Date.from_iso8601(end_date)

    Date.range(start_date, end_date)
    |> Enum.count(fn date ->
      date.year == year &&
        Date.day_of_week(date) in 1..5
    end)
  end
end
