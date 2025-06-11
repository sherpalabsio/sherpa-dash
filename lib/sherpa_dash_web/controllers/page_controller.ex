defmodule SherpaDashWeb.PageController do
  use SherpaDashWeb, :controller

  def home(conn, _params) do
    data = SherpaDash.Hibob.Holidays.data_for(2025)

    render(conn, :home, layout: false, data: data)
  end
end
