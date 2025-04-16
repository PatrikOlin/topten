defmodule TopTen.Lists.TopTenList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "top_ten_lists" do
    field :description, :string
    field :title, :string
    field :slug, :string
    field :rating, :integer, default: 0
    field :creator_id, :string
    field :creator_name, :string
    has_many :items, TopTen.Items.Item, foreign_key: :list_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(top_ten_list, attrs) do
    top_ten_list
    |> cast(attrs, [:title, :description, :slug, :creator_id, :creator_name])
    |> validate_required([:title])
    |> generate_slug()
  end

  def vote_changeset(top_ten_list, direction) do
    current_rating = top_ten_list.rating || 0

    new_rating =
      case direction do
	:up -> current_rating + 1
	:down -> current_rating - 1
      end

    top_ten_list
    |> change(%{rating: new_rating})
    |> validate_required([:rating])
    |> validate_number(:rating, greater_than_or_equal_to: -10000)
    |> validate_number(:rating, less_than_or_equal_to: 10000)
  end

  defp generate_slug(changeset) do
    case get_change(changeset, :title) do
      nil -> changeset
      title when is_binary(title) ->
	slug = title
	|> transliterate_swedish_chars()         # Handle ÅÄÖ
	|> String.downcase()
        |> String.replace(~r/[^a-z0-9\s-]/, "")  # Remove special chars
        |> String.replace(~r/\s+/, "-")          # Replace spaces with hyphens
        |> String.trim("-")                      # Trim hyphens from start/end

	random_suffix = :crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)
	unique_slug = "#{slug}-#{random_suffix}"
      
	put_change(changeset, :slug, unique_slug)
    end
  end

  defp transliterate_swedish_chars(string) do
    string
    |> String.replace(["å", "Å", "ä", "Ä"], "a")
    |> String.replace(["ö", "Ö"], "o")
  end
      
end
