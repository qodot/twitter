defmodule TwitterWeb.TimelineLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="px-2">
      <form class="w-full mx-auto pt-2 flex flex-col gap-2">
        <div>
          <input
            type="text"
            placeholder="닉네임"
            name="nickname"
            value={@nickname}
            class="flex h-10 px-3 py-2 text-sm bg-white border rounded-md border-neutral-300 ring-offset-background placeholder:text-neutral-500 focus:border-neutral-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-neutral-400 disabled:cursor-not-allowed disabled:opacity-50"
            phx-change="nickname_changed"
            phx-debounce="500"
          />
        </div>

        <div class="w-full">
          <textarea
            type="text"
            placeholder="무슨 일이 일어나고 있나요?"
            name="content"
            value={@content}
            class="flex w-full h-auto min-h-[80px] px-3 py-2 text-sm bg-white border rounded-md border-neutral-300 placeholder:text-neutral-400 focus:border-neutral-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-neutral-400 disabled:cursor-not-allowed disabled:opacity-50"
            phx-change="content_changed"
            phx-debounce="100"
          ></textarea>
        </div>

        <div class="flex flex-row justify-between items-center">
          <div>
            <%= case @content |> String.length() do %>
              <% length when length < 100 -> %>
                <span class="text-green-500 border border-green-500 text-md font-semibold py-1 px-1.5 rounded-full">
                  {length}
                </span>
              <% length when length <= 140 -> %>
                <span class="text-yellow-500 border border-yellow-500 text-md font-semibold py-1 px-1.5 rounded-full">
                  {length}
                </span>
              <% length when length > 140 -> %>
                <span class="text-red-500 border border-red-500 text-md font-semibold py-1 px-1.5 rounded-full">
                  {length}
                </span>
            <% end %>
          </div>

          <div>
            <%= if @content |> String.length() <= 140 do %>
              <button
                type="button"
                class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium tracking-wide text-white transition-colors duration-200 rounded-md bg-neutral-950 hover:bg-neutral-900 focus:ring-2 focus:ring-offset-2 focus:ring-neutral-900 focus:shadow-outline focus:outline-none"
                phx-click="tweet"
              >
                트윗!
              </button>
            <% else %>
              <button
                disabled
                type="button"
                class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium tracking-wide transition-colors duration-200 bg-white border rounded-md text-neutral-500 active:bg-white focus:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-neutral-200/60 focus:shadow-outline"
              >
                너무 길어요...
              </button>
            <% end %>
          </div>
        </div>
      </form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, nickname: "", content: "")}
  end

  def handle_event(
        "nickname_changed",
        %{"_target" => ["nickname"], "nickname" => nickname},
        socket
      ) do
    {:noreply, assign(socket, nickname: nickname)}
  end

  def handle_event("content_changed", %{"_target" => ["content"], "content" => content}, socket) do
    {:noreply, assign(socket, content: content)}
  end
end
