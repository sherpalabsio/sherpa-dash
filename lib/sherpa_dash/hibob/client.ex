defmodule SherpaDash.Hibob.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.hibob.com/v1"

  plug Tesla.Middleware.Headers, [
    {"accept", "application/json"},
    {"Authorization", "" <> System.get_env("HIBOB_TOKEN")}
  ]

  plug Tesla.Middleware.JSON

  def get_time_off() do
    year = DateTime.utc_now().year
    start_date = "#{year}-01-01"
    end_date = "#{year}-12-31"

    {:ok, response} =
      get("/timeoff/whosout",
        query: [
          from: start_date,
          to: end_date
        ]
      )

    response_body = response.body

    response_body["outs"]
    |> Enum.filter(fn out ->
      out["employeeId"] == System.get_env("HIBOB_EMPLOYEE_ID") &&
        out["policyTypeDisplayName"] == "Absence"
    end)
    |> Enum.reduce(0, fn out, acc ->
      acc + work_days_between(out["startDate"], out["endDate"])
    end)
  end

  def work_days_between(start_date, end_date) do
    {:ok, start_date} = Date.from_iso8601(start_date)
    {:ok, end_date} = Date.from_iso8601(end_date)

    Date.range(start_date, end_date)
    |> Enum.reduce(0, fn date, acc ->
      if Date.day_of_week(date) in [6, 7] do
        acc
      else
        acc + 1
      end
    end)
  end
end
