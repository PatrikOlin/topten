defmodule TopTenWeb.ListLive.New do
  use TopTenWeb, :live_view
  alias TopTen.Lists
  alias TopTen.Lists.TopTenList
  alias TopTen.Lists.Item

  @impl true
  def mount(_params, session, socket) do

    {:ok,
     socket
     |> assign(:changeset, Lists.change_top_ten_list(%TopTenList{}))
     |> assign(:items, [%{id: "item-1", position: 1, content: "", notes: ""}])
     |> assign(:next_position, 2)
    }
  end

  @impl true
  def handle_event("add-item", _params, socket) do
    # Don't add more than 10 items
    if length(socket.assigns.items) >= 10 do
      {:noreply, socket}
    else
      position = socket.assigns.next_position
      user_name = socket.assigns.current_user.name
      user_id = socket.assigns.current_user.id
      new_item = %{id: "item-#{position}", position: position, content: "", notes: "", creator_id: user_id, creator_name: user_name }

      {:noreply,
       socket
       |> assign(:items, socket.assigns.items ++ [new_item])
       |> assign(:next_position, position + 1)
      }
    end
  end

  @impl true
  def handle_event("remove-item", %{"position" => position}, socket) do
    position = String.to_integer(position)

    # Don't remove if only one item left
    if length(socket.assigns.items) <= 1 do
      {:noreply, socket}
    else
      # Remove the item and reposition the remaining items
      remaining_items = Enum.reject(socket.assigns.items, &(&1.position == position))

      # Reposition items to ensure sequential positions
      updated_items =
	remaining_items
	|> Enum.sort_by(& &1.position)
	|> Enum.with_index(1)
	|> Enum.map(fn {item, new_pos} ->
	  %{id: "item-#{new_pos}", position: new_pos, content: item.content, notes: item.notes}
	end)

      {:noreply,
       socket
       |> assign(:items, updated_items)
       |> assign(:next_position, length(updated_items) + 1)}
    end
  end

  @impl true
  def handle_event("save", %{"top_ten_list" => list_params, "items" => items_params}, socket) do
    # Convert items from map to list
    items = 
      socket.assigns.items
      |> Enum.map(fn item -> 
        item_key = Integer.to_string(item.position)
        item_data = Map.get(items_params, item_key, %{})
        
        %{
          position: item.position,
          content: Map.get(item_data, "content", ""),
          notes: Map.get(item_data, "notes", ""),
	  creator_id: socket.assigns.current_user.id,
	  creator_name: socket.assigns.current_user.name
        }
      end)
    
    list_params = Map.merge(list_params, %{
		    "creator_id" => socket.assigns.current_user.id,
		    "creator_name" => socket.assigns.current_user.name,
		  }) 
    
    # Add debugging
    IO.inspect(list_params, label: "List params")
    IO.inspect(items, label: "Items to create")
  
    # Call create function
    result = Lists.create_top_ten_list(list_params, items)
    IO.inspect(result, label: "Create result")
  
    case result do
      {:ok, list} ->
	{:noreply,
	 socket
	 |> put_flash(:info, "Lista skapad!")
	 |> redirect(to: ~p"/lists/#{list.slug}")}

      {:error, changeset} ->
	IO.inspect(changeset.errors, label: "Changeset errors")
	{:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"top_ten_list" => list_params, "items" => items_params}, socket) do
    changeset =
      %TopTenList{}
    |> Lists.change_top_ten_list(list_params)
    |> Map.put(:action, :validate)

    # Update items with changed values, maintaining existing items
    updated_items =
      Enum.map(socket.assigns.items, fn item ->
	item_key = Integer.to_string(item.position)
	item_data = Map.get(items_params, item_key, %{})

	%{
	  id: item.id,
	  position: item.position,
	  content: Map.get(item_data, "content", item.content),
	  notes: Map.get(item_data, "notes", item.notes)
	}
      end)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:items, updated_items)
    }
  end

  @impl true
  def handle_event("reorder", %{"positions" => positions}, socket) do
    new_order =
      positions
      |> Enum.map(fn {id, position} ->
	position_int = if is_integer(position), do: position, else: String.to_integer(position)
	{id, position_int}
      end)
      |> Enum.sort_by(fn {_, position} -> position end)

    updated_items =
      new_order
      |> Enum.with_index(1)
      |> Enum.map(fn {{id, _}, new_position} ->
	original_item = Enum.find(socket.assigns.items, fn item -> item.id == id end)

	%{
	  id: id,
	  position: new_position,
	  content: original_item.content,
	  notes: original_item.notes
	}
      end)

    {:noreply, assign(socket, items: updated_items)}
  end

 @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-6">Skapa en ny lista!</h1>
      
      <.form
        :let={f}
        for={@changeset}
        id="list-form"
        phx-change="validate"
        phx-submit="save"
      >
        <div class="space-y-6">
          <div>
            <.input field={f[:title]} label="Titel" placeholder="Ett fräckt namn" required />
          </div>
          
          <div>
            <.input field={f[:description]} type="textarea" label="Beskrivning" placeholder="Skriv en rad till ditt försvar..." />
          </div>
          
          <div class="pt-4">
            <div class="flex justify-between items-center mb-4">
              <h2 class="text-xl font-bold">Listrader (<%= length(@items) %>/10)</h2>
              
              <button 
                :if={length(@items) < 10}
                type="button" 
                phx-click="add-item" 
                class="bg-lorange-100 hover:bg-lorange-80 text-white py-1 px-3 rounded text-sm"
              >
                + Lägg till rad
              </button>
            </div>
            
            <p class="text-sm text-gray-600 mb-6 dark:text-stone-200">
	      Lägg till minst en rad till listan. Du kan lägga till upp till 10 rader, eller vara lite schysst och lämna plats för nån annan att delta också.
            </p>
            
            <div class="space-y-4" id="items-container" phx-hook="Sortable">
              <%= for item <- @items do %>
	      <fieldset class="border dark:border-lorange-40 rounded-lg p-4 relative cursor-move" 
		id={"#{item.id}"} 
		data-position={item.position}>
		<legend class="font-bold px-2">Rad #<%= item.position %></legend>
		<div class="flex items-center justify-end">
		  <div class="flex items-center">
		    <button 
		      :if={length(@items) > 1}
		      type="button" 
		      phx-click="remove-item" 
		      phx-value-position={item.position}
		      class="text-red-500 hover:text-red-700 mr-2"
		      aria-label="Ta bort rad"
		    >
		      ✕
		    </button>
          
		    <div class="text-gray-400 cursor-move">
		      ⠿
		    </div>
		  </div>
		</div>
                  
                <div class="space-y-3">
                  <.input name={"items[#{item.position}][content]"} value={item.content} label="Innehåll" placeholder="!?" required />
                  <.input name={"items[#{item.position}][notes]"} value={item.notes} label="Förklaring (valfritt)"
		      placeholder="Vad menar du?" />
                </div>
              </fieldset>
              <% end %>
            </div>
          </div>
          
          <div class="pt-4">
            <.button class="dark:bg-lorange-100 dark:text-stone-200 dark:hover:bg-lorange-80" type="submit" phx-disable-with="Skapar...">
              Skapa lista
            </.button>
            <a href="/" class="ml-4 text-gray-600 dark:text-stone-200 hover:underline">Avbryt</a>
          </div>
        </div>
      </.form>
    </div>
    """
  end
end
