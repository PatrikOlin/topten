defmodule TopTen.Repo.Migrations.AddUserToLists do
  use Ecto.Migration

  def change do
    alter table(:top_ten_lists) do
      add :creator_id, :string
      add :creator_name, :string
    end

    alter table(:items) do
      add :creator_id, :string
      add :creator_name, :string
    end

  end
end
