defmodule Flightex.Bookings.Agent do
  alias Flightex.Bookings.Booking
  use Agent

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking) do
    uuid = UUID.uuid4()

    Agent.update(__MODULE__, &update_state(&1, booking, uuid))
    {:ok, uuid}
  end

  def list_all() do
    Agent.get(__MODULE__, & &1)
  end

  def list_by_interval(from_date, to_date) do
    Agent.get(__MODULE__, &filter_by_interval(&1, from_date, to_date))
  end

  def get(uuid), do: Agent.get(__MODULE__, &get_booking(&1, uuid))

  defp get_booking(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end

  defp update_state(state, %Booking{} = booking, uuid), do: Map.put(state, uuid, booking)

  defp filter_by_interval(state, from_date, to_date) do
    Enum.filter(state, fn {_uuid, booking} ->
      booking.complete_date >= from_date and booking.complete_date <= to_date
    end)
    |> Map.new()
  end
end
