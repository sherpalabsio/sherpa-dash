defmodule SherpaDashWeb.AuthController do
  use SherpaDashWeb, :controller
  plug Ueberauth

  alias Ueberauth.Auth

  def request(conn, _params) do
    # Ueberauth handles the redirect
    redirect(conn, external: "/auth/google")
  end

  def callback(%{assigns: %{ueberauth_auth: %Auth{} = auth}} = conn, _params) do
    user = %{
      uid: auth.uid,
      email: auth.info.email
    }

    conn
    |> put_session(:user, user)
    |> put_flash(:info, "Successfully authenticated as #{user.email}")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed: #{inspect(fails)}")
    |> redirect(to: "/")
  end
end
