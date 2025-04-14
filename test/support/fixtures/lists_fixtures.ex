defmodule TopTen.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TopTen.Lists` context.
  """

  @doc """
  Generate a top_ten_list.
  """
  def top_ten_list_fixture(attrs \\ %{}) do
    {:ok, top_ten_list} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> TopTen.Lists.create_top_ten_list()

    top_ten_list
  end
end
