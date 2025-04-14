defmodule TopTen.Repo.Migrations.AddListsUpvotes do
  use Ecto.Migration

  def change do
    alter table(:top_ten_lists) do
      add :upvotes, :integer
      add :downvotes, :integer
    end
  end
end
