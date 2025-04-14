defmodule TopTen.Repo.Migrations.CreateTopTenLists do
  use Ecto.Migration

  def change do
    create table(:top_ten_lists) do
      add :title, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
