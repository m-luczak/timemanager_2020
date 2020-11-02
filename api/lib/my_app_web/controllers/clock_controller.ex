defmodule MyAppWeb.ClockController do
  use MyAppWeb, :controller

  alias MyApp.Accounts
  alias MyApp.TimeTrackers
  alias MyApp.TimeTrackers.Clock

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    clocks = TimeTrackers.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- TimeTrackers.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end


  def create_for_user(conn, %{"id" => id, "clock" => clock_params}) do
    case Ecto.UUID.cast(id) do
      :error ->
        conn 
        |> put_status(400) 
        |> render("error.json", %{message: "User id not good"})
      {:ok, uuid} ->
        case Accounts.get_user!(uuid) do
          {:ok, user} ->
            with {:ok, %Clock{} = clock} <- TimeTrackers.create_clock_for_user(id, clock_params) do
              TimeTrackers.check_endclock_create_workingtime(clock)
              conn
              |> put_status(:created)
              |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
              |> render("show.json", clock: clock)
            end
          _ ->
            conn |> put_status(404) |> render("error.json", %{message: "User not found"})
        end
      end
end



  def show(conn, %{"id" => id}) do
    clocks = TimeTrackers.get_clock_by_user!(id)
    render(conn, "index.json", clocks: clocks)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = TimeTrackers.get_clock!(id)
    with {:ok, %Clock{} = clock} <- TimeTrackers.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = TimeTrackers.get_clock!(id)
    with {:ok, %Clock{}} <- TimeTrackers.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
