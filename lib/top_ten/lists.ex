defmodule TopTen.Lists do
  alias TopTen.Items.Item

  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias TopTen.Repo

  alias TopTen.Lists.TopTenList

  @doc """
  Returns the list of top_ten_lists.

  ## Examples

      iex> list_top_ten_lists()
      [%TopTenList{}, ...]

  """
  def list_top_ten_lists do
    Repo.all(TopTenList)
  end

  @doc """
  Gets a single top_ten_list.

  Raises `Ecto.NoResultsError` if the Top ten list does not exist.

  ## Examples

      iex> get_top_ten_list!(123)
      %TopTenList{}

      iex> get_top_ten_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_top_ten_list!(id), do: Repo.get!(TopTenList, id)

  @doc """
  Creates a top_ten_list.

  ## Examples

      iex> create_top_ten_list(%{field: value})
      {:ok, %TopTenList{}}

      iex> create_top_ten_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_top_ten_list(attrs \\ %{}, items \\ []) do
    %TopTenList{}
    |> TopTenList.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:items, Enum.map(items, &Item.changeset(%Item{}, &1)))
    |> Repo.insert()
  end

  @doc """
  Updates a top_ten_list.

  ## Examples

      iex> update_top_ten_list(top_ten_list, %{field: new_value})
      {:ok, %TopTenList{}}

      iex> update_top_ten_list(top_ten_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_top_ten_list(%TopTenList{} = top_ten_list, attrs) do
    top_ten_list
    |> TopTenList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a top_ten_list.

  ## Examples

      iex> delete_top_ten_list(top_ten_list)
      {:ok, %TopTenList{}}

      iex> delete_top_ten_list(top_ten_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_top_ten_list(%TopTenList{} = top_ten_list) do
    Repo.delete(top_ten_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking top_ten_list changes.

  ## Examples

      iex> change_top_ten_list(top_ten_list)
      %Ecto.Changeset{data: %TopTenList{}}

  """
  def change_top_ten_list(%TopTenList{} = top_ten_list, attrs \\ %{}) do
    TopTenList.changeset(top_ten_list, attrs)
  end

  def update_top_ten_list(%TopTenList{} = list, attrs, items) do
    Repo.transaction(fn ->
      # Update the list itself
      list_changeset = TopTenList.changeset(list, attrs)
      {:ok, updated_list} = Repo.update(list_changeset)
    
      # Delete all existing items
      Repo.delete_all(from(i in Item, where: i.list_id == ^list.id))
    
      # Create new items
      Enum.each(items, fn item_attrs ->
	%Item{}
	|> Item.changeset(Map.put(item_attrs, :list_id, list.id))
	|> Repo.insert!()
      end)
    
      updated_list
    end)
  end

  def get_list_by_slug!(slug) do
    Repo.get_by!(TopTenList, slug: slug)
    |> Repo.preload(:items)
  end

  def list_recent_lists(limit \\ 10) do
    TopTenList
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def search_lists(search_term) do
    TopTenList
    |> where([l], ilike(l.title, ^search_term) or ilike(l.description, ^search_term))
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def upvote_list(list) do
    list
    |> TopTenList.vote_changeset(:up)
    |> Repo.update()
  end

  def downvote_list(list) do
    list
    |> TopTenList.vote_changeset(:down)
    |> Repo.update()
  end
  
end
