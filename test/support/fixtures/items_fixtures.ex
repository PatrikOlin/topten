defmodule TopTen.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TopTen.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        content: "some content",
        notes: "some notes",
        position: 42
      })
      |> TopTen.Items.create_item()

    item
  end
end
