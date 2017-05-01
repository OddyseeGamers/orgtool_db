defmodule OrgtoolDb.Repo.Migrations.RemoveItemType do
  use Ecto.Migration

  def change do
    alter table(:items) do
      remove :item_id
      remove :item_type_id
      add :model_id, references(:models)
    end
    drop table(:item_types)
  end
end
