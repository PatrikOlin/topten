defmodule TopTen.Repo.Migrations.AddSlugToTopTenLists do
  use Ecto.Migration

  def change do
    alter table(:top_ten_lists) do
      add :slug, :string
    end

    create unique_index(:top_ten_lists, [:slug])
  end
end
