defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :brightness, 10)}
  end

  def render(assigns) do
    ~L"""
    <h1>Front porch light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src ="images/light-off.svg">
      </button>

      <button phx-click="down">
        <img src ="images/down.svg">
      </button>

      <button phx-click="up">
        <img src ="images/up.svg">
      </button>

      <button phx-click="on">
        <img src ="images/light-on.svg">
      </button>
    </div>
    """
  end

  def handle_event("on", _, socket) do
    {:noreply, assign(socket, :brightness, 100)}
  end

  def handle_event("off", _, socket) do
    {:noreply, assign(socket, :brightness, 0)}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &(&1 + 10))

    cond do
      socket.assigns.brightness >= 100 ->
        {:noreply, assign(socket, :brightness, 100)}

      socket.assigns.brightness < 100 ->
        {:noreply, socket}
    end
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &(&1 - 10))
    cond do
      socket.assigns.brightness <= 0 ->
        {:noreply, assign(socket, :brightness, 0)}

      socket.assigns.brightness > 0 ->
        {:noreply, socket}
    end
  end
end
