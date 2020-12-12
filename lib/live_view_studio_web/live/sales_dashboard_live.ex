defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(interval: 1)

    if connected?(socket) do
      Process.send_after(self(), :tick, socket.assigns.interval)
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>

      <div>
        <form phx-change="select-refresh">
          <select name="refresh">
            <%= options_for_select(refresh_options(), @interval) %>
          </select>
        </form>
      </div>

      <button phx-click="refresh">
        <img src="images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  def handle_event("select-refresh", %{"refresh" => interval}, socket) do
    interval = String.to_integer(interval)
    socket = assign(socket, interval: interval)

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign_stats(socket)

    Process.send_after(self(), :tick, socket.assigns.interval)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end

  def refresh_options do
    [{"1s", 1}, {"5s", 5}, {"15s", 15}, {"30s", 30}, {"60s", 60}]
  end
end
