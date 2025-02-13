defmodule TwitterWeb.TimelineLive do
  use TwitterWeb, :live_view

  @impl true
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
            phx-debounce="200"
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
            <%= case @validate do %>
              <% {:ok, button_name} -> %>
                <button
                  type="button"
                  class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium tracking-wide text-white transition-colors duration-200 rounded-md bg-neutral-950 hover:bg-neutral-900 focus:ring-2 focus:ring-offset-2 focus:ring-neutral-900 focus:shadow-outline focus:outline-none"
                  phx-click="tweet"
                >
                  {button_name}
                </button>
              <% {:error, error_message} -> %>
                <button
                  disabled
                  type="button"
                  class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium tracking-wide transition-colors duration-200 bg-white border rounded-md text-neutral-500 active:bg-white focus:bg-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-neutral-200/60 focus:shadow-outline"
                >
                  {error_message}
                </button>
            <% end %>
          </div>
        </div>
      </form>

      <div id="timeline-streams-tweets" class="flex flex-col gap-2 mt-10 p-3" phx-update="stream">
        <blockquote
          :for={{id, tweet} <- @streams.tweets}
          id={id}
          class="w-full border border-neutral-200 rounded-lg p-5"
        >
          <p class="text-gray-800">
            <em>
              {tweet.content}
            </em>
          </p>

          <footer class="mt-3">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://cdn.devdojo.com/images/june2023/johndoe.png"
                  alt="John Doe"
                />
              </div>
              <div class="ml-3">
                <div class="text-base font-semibold text-gray-800">
                  {tweet.nickname}
                </div>
                <div class="text-xs text-gray-500">
                  {tweet.inserted_at |> DateTime.to_string() |> String.slice(0, 19)}
                </div>
              </div>
            </div>
          </footer>
        </blockquote>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       nickname: "",
       content: "",
       validate: validate("", "")
     )
     |> stream(:tweets, Twitter.Tweets.timeline())}
  end

  @impl true
  def handle_event(
        "nickname_changed",
        %{"_target" => ["nickname"], "nickname" => nickname},
        socket
      ) do
    {:noreply,
     assign(socket,
       nickname: nickname,
       validate: validate(nickname, socket.assigns.content)
     )}
  end

  @impl true
  def handle_event("content_changed", %{"_target" => ["content"], "content" => content}, socket) do
    {:noreply,
     assign(socket, content: content, validate: validate(socket.assigns.nickname, content))}
  end

  @impl true
  def handle_event("tweet", _params, socket) do
    tweet = Twitter.Tweets.tweet(socket.assigns.nickname, socket.assigns.content)

    {:noreply,
     socket
     |> assign(
       content: "",
       validate: validate(tweet.nickname, "")
     )
     |> stream_insert(:tweets, tweet, at: 0)}
  end

  defp validate("", _) do
    {:error, "닉네임이 없어요..."}
  end

  defp validate(_, "") do
    {:error, "내용이 없어요..."}
  end

  defp validate(_nickname, content) when byte_size(content) > 420 do
    {:error, "너무 길어요..."}
  end

  defp validate(_nickname, _content) do
    {:ok, "트윗!"}
  end
end
