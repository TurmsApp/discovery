defmodule Turms.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :date, :utc_datetime
      add :attachements, {:array, :integer}
      add :user_vanity, references(:users, column: :vanity, type: :string, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:user_vanity])
  end
end
