defmodule SherpaDashWeb.PageController do
  use SherpaDashWeb, :controller

  plug :require_authenticated_user when action in [:home]

  def home(conn, _params) do
    data = SherpaDash.Hibob.Holidays.data_for(2025)

    render(conn, :home, layout: false, data: data)
  end

  defp require_authenticated_user(conn, _opts) do
    if get_session(conn, :user) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: "/auth/google")
      |> halt()
    end
  end
end
