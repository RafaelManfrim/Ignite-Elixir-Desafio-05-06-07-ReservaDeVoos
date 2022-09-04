defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(from_date, to_date) do
    booking_list = build_filtered_booking_list(from_date, to_date)

    File.write("interval_report.csv", booking_list)
  end

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  defp build_booking_list() do
    BookingAgent.list_all() |> Map.values() |> Enum.map(fn booking -> booking_string(booking) end)
  end

  defp build_filtered_booking_list(from_date, to_date) do
    BookingAgent.list_by_interval(from_date, to_date)
    |> Map.values()
    |> Enum.map(fn booking -> booking_string(booking) end)
  end

  defp booking_string(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
