defmodule SherpaDash.Hibob.RequestError do
  defexception [:status]

  @impl true
  def message(%{status: status}) do
    "HiBob request error (status: #{status})"
  end
end
