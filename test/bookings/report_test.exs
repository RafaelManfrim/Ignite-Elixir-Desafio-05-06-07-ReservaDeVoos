defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Users.Agent, as: UserAgent

  describe "generate/0" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      user_params = %{
        cpf: "12345",
        name: "Rafael",
        email: "rafael@email.com"
      }

      Flightex.create_or_update_user(user_params)

      {:ok, %{id: user_id}} = UserAgent.get("12345")

      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: user_id,
        id: UUID.uuid4()
      }

      content = "#{user_id},Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Flightex.generate_report()
      {:ok, file} = File.read("report.csv")

      assert file =~ content
    end
  end

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Flightex.generate_report("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate/2" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Flightex.generate_report(~N[2001-05-07 12:00:00], ~N[2001-05-07 12:00:00])
      {:ok, file} = File.read("interval_report.csv")

      assert file =~ content
    end
  end
end
