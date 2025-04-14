defmodule TopTen.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :content, :string
      add :position, :integer
      add :notes, :text
      add :list_id, references(:top_ten_lists, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:list_id])
  end
end
