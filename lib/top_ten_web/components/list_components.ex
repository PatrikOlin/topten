defmodule TopTenWeb.ListComponents do
  use Phoenix.Component

  attr :list, :map, required: true
  attr :link_text, :string, default: "Kolla in listan →"
  attr :class, :string, default: ""

  def list_card(assigns) do
    ~H"""
    <div class={"flex flex-col justify-between border dark:border-lorange-100 dark:bg-slate-900 dark:text-stone-200 rounded-lg p-4 hover:shadow-md transition-shadow #{@class}"}>
      <div class="flex flex-col items-start mb-4">
	<h3 class="font-bold text-lg mb-0"><%= @list.title %></h3>
	<p class="text-gray-400 dark:text-stone-400 text-xs">Uppdaterad: <%= format_datetime(@list.updated_at) %></p>
      </div>
      <p class="text-gray-600 dark:text-stone-300 text-sm mb-4"><%= @list.description %></p>
      <div class="flex flex-row justify-between">
	<span class="font-normal text-sm dark:text-stone-400">
	  Poäng <%= @list.rating %>
	</span>
	<a href={"/lists/#{@list.slug}"} class="text-blue-500 dark:text-lorange-100 hover:underline">
          <%= @link_text %>
	</a>
      </div>
    </div>
    """
  end

  defp format_datetime(datetime) do
    diff_seconds = DateTime.diff(DateTime.utc_now(), datetime)

    cond do
      diff_seconds < 60 -> "Nyss"
      diff_seconds < 3600 -> "#{div(diff_seconds, 60)} minuter sedan"
      diff_seconds < 86400 -> "#{div(diff_seconds, 3600)} timmar sedan"
      diff_seconds < 172800 -> "Igår"
      diff_seconds < 2592000 -> "#{div(diff_seconds, 86400)} dagar sedan"
      true -> Calendar.strftime(datetime, "%d %b %Y")
    end
  end
  
end
