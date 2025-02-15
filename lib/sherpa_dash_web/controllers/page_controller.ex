defmodule SherpaDashWeb.PageController do
  use SherpaDashWeb, :controller

  def home(conn, _params) do
    result = SherpaDash.Hibob.Holidays.min_max_days_remaining(2025)

    render(conn, :home, layout: false, result: result)
  end
end
