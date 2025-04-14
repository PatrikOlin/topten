defmodule TopTenWeb.PageLive do
  use TopTenWeb, :live_view
  alias TopTen.Lists

  # Components
  import TopTenWeb.ListComponents

  @impl true
  def mount(_parans, _session, socket) do
    lists = Lists.list_recent_lists(10)
    sort_options = [
      {"Senaste", "newest"},
      {"Bästa", "best"},
      {"Sämsta", "worst"}
    ]
    {:ok, assign(socket,
		 query: "",
		 lists: lists,
		 filtered_lists: lists,
		 sort_options: sort_options,
		 current_sort: "newest"
	  )}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    filtered_lists =
      if query == "" do
	socket.assigns.lists
      else
	search_term = "%#{query}%"
	Lists.search_lists(search_term)
      end

    {:noreply, assign(socket, query: query, filtered_lists: filtered_lists)}
  end

  @impl true
  def handle_event("sort", %{"sort" => sort_option}, socket) do
    sorted_lists = sort_lists(socket.assigns.lists, sort_option)
  
    {:noreply, assign(socket, lists: sorted_lists, current_sort: sort_option)}
  end

  defp sort_lists(lists, sort_option) do
    case sort_option do
      "newest" -> Enum.sort_by(lists, & &1.inserted_at, {:desc, DateTime})
      "best" -> Enum.sort_by(lists, & &1.rating, :desc)
      "worst" -> Enum.sort_by(lists, & &1.rating, :asc)
      _ -> lists
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <div class="flex flex-col">
      <div class="mb-8">
	<h1 class="text-3xl font-bold mb-2">Skapa en lista, vetja!</h1>
      </div>

        <form phx-change="search" class="mb-6">
          <input 
            type="text" 
            name="q" 
            value={@query} 
            placeholder="Sök lista..." 
            class="px-4 py-2 border rounded-lg w-full dark:border-lorange-100 dark:color-stone-200 dark:placeholder-stone-400 dark:bg-slate-900"
            phx-debounce="300"
          />
        </form>
        
        <div class="grid mb-8 gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
          <%= for list <- @filtered_lists do %>
	     <.list_card list={list} link_text="Kolla in listan →" class="bg-gray-50" />
          <% end %>

          <%= if Enum.empty?(@filtered_lists) do %>
            <p class="col-span-full italic text-gray-500">
              <%= if @query == "" do %>
                Hittade inga listor. Be the change you want to see, skapa en!
              <% else %>
                Du, det finns visst ingen sån lista.
              <% end %>
            </p>
          <% end %>
        </div>
      </div>

      <figure>
	<blockquote class="flex flex-col text-lg text-lorange-100">
	  <svg class="w-8 h-8 text-gray-400 dark:text-lorange-100 mb-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 18 14">
            <path d="M6 0H2a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h4v1a3 3 0 0 1-3 3H2a1 1 0 0 0 0 2h1a5.006 5.006 0 0 0 5-5V2a2 2 0 0 0-2-2Zm10 0h-4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h4v1a3 3 0 0 1-3 3h-1a1 1 0 0 0 0 2h1a5.006 5.006 0 0 0 5-5V2a2 2 0 0 0-2-2Z"/>
	  </svg>
	  <p class="text-2xl text-center italic font-semibold">Topp10 borde göra en comeback rent allmänt</p>
	</blockquote>
	<figcaption class="flex items-center justify-center mt-6 space-x-3 rtl:space-x-reverse">
        <div class="flex items-center divide-x-2 rtl:divide-x-reverse divide-gray-500 dark:divide-gray-700">
            <cite class="pe-3 font-medium text-gray-900 dark:text-white">Farcus "Släggan" Morslin</cite>
            <cite class="ps-3 text-sm text-gray-500 dark:text-gray-400">Löntagare</cite>
        </div>
	</figcaption>
      </figure>
      
      <div class="mt-8">
	<div class="flex flex-row justify-between mb-4">
          <h2 class="text-2xl font-bold mb-4">Senaste listorna</h2>
	  <form phx-change="sort">
	    <.input type="select" name="sort" options={@sort_options} value={@current_sort} />
	  </form>
	</div>

        <div class="grid gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
          <%= for list <- @lists do %>
	     <.list_card list={list} link_text="Kolla in listan →" class="bg-gray-50" />
          <% end %>
        
      </div>
    </div>
    </div>
    """
  end

end
