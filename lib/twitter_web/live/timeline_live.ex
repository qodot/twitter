defmodule TwitterWeb.TimelineLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="px-2">
      <div class="w-full mx-auto pt-2 flex flex-col gap-2">
        <div>
          <input
            type="text"
            placeholder="닉네임"
            class="flex h-10 px-3 py-2 text-sm bg-white border rounded-md border-neutral-300 ring-offset-background placeholder:text-neutral-500 focus:border-neutral-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-neutral-400 disabled:cursor-not-allowed disabled:opacity-50"
          />
        </div>

        <div class="w-full">
          <textarea
            type="text"
            placeholder="무슨 일이 일어나고 있나요?"
            class="flex w-full h-auto min-h-[80px] px-3 py-2 text-sm bg-white border rounded-md border-neutral-300 placeholder:text-neutral-400 focus:border-neutral-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-neutral-400 disabled:cursor-not-allowed disabled:opacity-50"
          ></textarea>
        </div>

        <div class="flex flex-row justify-between items-center">
          <div></div>

          <button
            type="button"
            class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium tracking-wide text-white transition-colors duration-200 rounded-md bg-neutral-950 hover:bg-neutral-900 focus:ring-2 focus:ring-offset-2 focus:ring-neutral-900 focus:shadow-outline focus:outline-none"
          >
            트윗!
          </button>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
