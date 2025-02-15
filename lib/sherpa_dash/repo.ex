defmodule SherpaDash.Repo do
  use Ecto.Repo,
    otp_app: :sherpa_dash,
    adapter: Ecto.Adapters.Postgres
end
