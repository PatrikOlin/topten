defmodule TopTen.Repo.Migrations.UpdateItemsForeignKey do
  use Ecto.Migration

  def up do
    drop constraint(:items, "items_list_id_fkey")
    alter table (:items) do
      modify :list_id, references(:top_ten_lists, on_delete: :delete_all)
    end
  end

  def down do
    drop constraint(:items, "items_list_id_fkey")
    alter table(:items) do
      modify :list_id, references(:top_ten_lists, on_delete: :nothing)
    end
  end
end
