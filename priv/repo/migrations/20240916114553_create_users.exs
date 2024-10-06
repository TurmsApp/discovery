defmodule Turms.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :vanity, :string, primary_key: true
      add :name, :string
      add :hashed_password, :string, default: nil, null: true
      add :public, :boolean, default: false, null: false
    end

    create unique_index(:users, [:vanity])
  end
end
