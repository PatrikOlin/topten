defmodule TopTen.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :position, :integer
    field :content, :string
    field :notes, :string
    belongs_to :top_ten_list, TopTen.Lists.TopTenList, foreign_key: :list_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :position, :notes, :list_id])
    |> validate_required([:content, :position])
  end
end
