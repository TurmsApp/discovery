defmodule Turms.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :from, :string
      add :content, :string
      add :user_vanity, references(:users, column: :vanity, type: :string, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:user_vanity])
  end
end
