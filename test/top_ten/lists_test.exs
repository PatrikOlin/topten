defmodule TopTen.ListsTest do
  use TopTen.DataCase

  alias TopTen.Lists

  describe "top_ten_lists" do
    alias TopTen.Lists.TopTenList

    import TopTen.ListsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_top_ten_lists/0 returns all top_ten_lists" do
      top_ten_list = top_ten_list_fixture()
      assert Lists.list_top_ten_lists() == [top_ten_list]
    end

    test "get_top_ten_list!/1 returns the top_ten_list with given id" do
      top_ten_list = top_ten_list_fixture()
      assert Lists.get_top_ten_list!(top_ten_list.id) == top_ten_list
    end

    test "create_top_ten_list/1 with valid data creates a top_ten_list" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %TopTenList{} = top_ten_list} = Lists.create_top_ten_list(valid_attrs)
      assert top_ten_list.description == "some description"
      assert top_ten_list.title == "some title"
    end

    test "create_top_ten_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_top_ten_list(@invalid_attrs)
    end

    test "update_top_ten_list/2 with valid data updates the top_ten_list" do
      top_ten_list = top_ten_list_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %TopTenList{} = top_ten_list} = Lists.update_top_ten_list(top_ten_list, update_attrs)
      assert top_ten_list.description == "some updated description"
      assert top_ten_list.title == "some updated title"
    end

    test "update_top_ten_list/2 with invalid data returns error changeset" do
      top_ten_list = top_ten_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_top_ten_list(top_ten_list, @invalid_attrs)
      assert top_ten_list == Lists.get_top_ten_list!(top_ten_list.id)
    end

    test "delete_top_ten_list/1 deletes the top_ten_list" do
      top_ten_list = top_ten_list_fixture()
      assert {:ok, %TopTenList{}} = Lists.delete_top_ten_list(top_ten_list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_top_ten_list!(top_ten_list.id) end
    end

    test "change_top_ten_list/1 returns a top_ten_list changeset" do
      top_ten_list = top_ten_list_fixture()
      assert %Ecto.Changeset{} = Lists.change_top_ten_list(top_ten_list)
    end
  end
end
