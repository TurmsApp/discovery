defmodule Turms.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :vanity, :string, primary_key: true
      add :name, :string
      add :password, :string
      add :date, :utc_datetime
      add :public, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:vanity])
  end
end
