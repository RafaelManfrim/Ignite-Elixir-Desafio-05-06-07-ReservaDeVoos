defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Users.Agent, as: UserAgent

  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser

  alias Flightex.Bookings.Report

  def start_agents() do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})
  end

  defdelegate create_or_update_booking(params), to: CreateOrUpdateBooking, as: :call
  defdelegate create_or_update_user(params), to: CreateOrUpdateUser, as: :call

  def generate_report() do
    Report.generate()
    {:ok, "Report generated successfully"}
  end

  def generate_report(filename) do
    Report.generate(filename)
    {:ok, "Report generated successfully"}
  end

  def generate_report(from_date, to_date) do
    Report.generate(from_date, to_date)
    {:ok, "Report generated successfully"}
  end
end
