defmodule TopTenWeb.TopTenListController do
  use TopTenWeb, :controller

  alias TopTen.Lists
  alias TopTen.Lists.TopTenList

  def index(conn, _params) do
    top_ten_lists = Lists.list_top_ten_lists()
    render(conn, :index, top_ten_lists: top_ten_lists)
  end

  def new(conn, _params) do
    changeset = Lists.change_top_ten_list(%TopTenList{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"top_ten_list" => top_ten_list_params}) do
    case Lists.create_top_ten_list(top_ten_list_params) do
      {:ok, top_ten_list} ->
        conn
        |> put_flash(:info, "Top ten list created successfully.")
        |> redirect(to: ~p"/top_ten_lists/#{top_ten_list}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    top_ten_list = Lists.get_top_ten_list!(id)
    render(conn, :show, top_ten_list: top_ten_list)
  end

  def edit(conn, %{"id" => id}) do
    top_ten_list = Lists.get_top_ten_list!(id)
    changeset = Lists.change_top_ten_list(top_ten_list)
    render(conn, :edit, top_ten_list: top_ten_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "top_ten_list" => top_ten_list_params}) do
    top_ten_list = Lists.get_top_ten_list!(id)

    case Lists.update_top_ten_list(top_ten_list, top_ten_list_params) do
      {:ok, top_ten_list} ->
        conn
        |> put_flash(:info, "Top ten list updated successfully.")
        |> redirect(to: ~p"/top_ten_lists/#{top_ten_list}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, top_ten_list: top_ten_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    top_ten_list = Lists.get_top_ten_list!(id)
    {:ok, _top_ten_list} = Lists.delete_top_ten_list(top_ten_list)

    conn
    |> put_flash(:info, "Top ten list deleted successfully.")
    |> redirect(to: ~p"/top_ten_lists")
  end
end
