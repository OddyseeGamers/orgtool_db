defmodule OrgtoolDb.Repo.Migrations.CreateProp do
  use Ecto.Migration

  def change do
    create table(:props) do
      add :name, :string
      add :value, :string
      add :description, :text
      add :img, :string
      add :item, :integer
      add :type, :integer
      add :unit, :integer

      timestamps()
    end

  end
end
