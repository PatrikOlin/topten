defmodule TopTenWeb.TopTenListControllerTest do
  use TopTenWeb.ConnCase

  import TopTen.ListsFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  describe "index" do
    test "lists all top_ten_lists", %{conn: conn} do
      conn = get(conn, ~p"/top_ten_lists")
      assert html_response(conn, 200) =~ "Listing Top ten lists"
    end
  end

  describe "new top_ten_list" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/top_ten_lists/new")
      assert html_response(conn, 200) =~ "New Top ten list"
    end
  end

  describe "create top_ten_list" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/top_ten_lists", top_ten_list: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/top_ten_lists/#{id}"

      conn = get(conn, ~p"/top_ten_lists/#{id}")
      assert html_response(conn, 200) =~ "Top ten list #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/top_ten_lists", top_ten_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Top ten list"
    end
  end

  describe "edit top_ten_list" do
    setup [:create_top_ten_list]

    test "renders form for editing chosen top_ten_list", %{conn: conn, top_ten_list: top_ten_list} do
      conn = get(conn, ~p"/top_ten_lists/#{top_ten_list}/edit")
      assert html_response(conn, 200) =~ "Edit Top ten list"
    end
  end

  describe "update top_ten_list" do
    setup [:create_top_ten_list]

    test "redirects when data is valid", %{conn: conn, top_ten_list: top_ten_list} do
      conn = put(conn, ~p"/top_ten_lists/#{top_ten_list}", top_ten_list: @update_attrs)
      assert redirected_to(conn) == ~p"/top_ten_lists/#{top_ten_list}"

      conn = get(conn, ~p"/top_ten_lists/#{top_ten_list}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, top_ten_list: top_ten_list} do
      conn = put(conn, ~p"/top_ten_lists/#{top_ten_list}", top_ten_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Top ten list"
    end
  end

  describe "delete top_ten_list" do
    setup [:create_top_ten_list]

    test "deletes chosen top_ten_list", %{conn: conn, top_ten_list: top_ten_list} do
      conn = delete(conn, ~p"/top_ten_lists/#{top_ten_list}")
      assert redirected_to(conn) == ~p"/top_ten_lists"

      assert_error_sent 404, fn ->
        get(conn, ~p"/top_ten_lists/#{top_ten_list}")
      end
    end
  end

  defp create_top_ten_list(_) do
    top_ten_list = top_ten_list_fixture()
    %{top_ten_list: top_ten_list}
  end
end
