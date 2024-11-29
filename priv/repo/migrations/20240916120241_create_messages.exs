defmodule Turms.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :vanity, :string, primary_key: true
      add :name, :string
      add :hashed_password, :string, default: nil, null: true
      add :public, :boolean, default: false, null: false
      timestamps()
    end
  end
end
