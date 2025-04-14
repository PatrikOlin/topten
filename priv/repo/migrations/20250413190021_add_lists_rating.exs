defmodule TopTen.Repo.Migrations.AddListsRating do
  use Ecto.Migration

  def change do
    alter table(:top_ten_lists) do
      remove :upvotes, :integer
      remove :downvotes, :integer
      add :rating, :integer, default: 0
    end
  end
end
