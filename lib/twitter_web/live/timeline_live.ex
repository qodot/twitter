defmodule TwitterWeb.TimelineLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Timeline</h1>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
