defmodule SherpaDash.Hibob.ClientTest do
  use ExUnit.Case, async: true

  describe "when the status code is not 2xx" do
    test "raises SherpaDash.Hibob.RequestError when status code is not 2xx" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 400}
      end)

      assert_raise SherpaDash.Hibob.RequestError, fn ->
        SherpaDash.Hibob.Client.number_of_taken_days()
      end
    end
  end

  describe "when the status code is 2xx" do
    test "returns the correct number of taken days" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{
            status: 200,
            headers: [{"content-type", "application/json"}],
            body: ~s|{
              "outs": [
                {
                  "startDate": "2024-01-01",
                  "endDate":   "2024-01-07",
                  "policyTypeDisplayName": "Absence",
                  "employeeId": "#{System.get_env("HIBOB_EMPLOYEE_ID")}",
                  "visibility": "Public",
                  "requestRangeType": "days",
                  "endDatePortion": "afternoon"
                }
              ]
            }|
          }
      end)

      time_off = SherpaDash.Hibob.Client.number_of_taken_days(2024)
      assert time_off == 5
    end
  end
end
