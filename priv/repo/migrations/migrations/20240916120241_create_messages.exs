defmodule Turms.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user_vanity, references(:users, column: :vanity, type: :string)
      timestamps()
    end

  create index(:messages, [:user_vanity])
  end
end
