defmodule Turms.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add :filename, :string
      add :content_type, :string
      add :blob, :binary
      add :message_id, references(:messages, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:attachments, [:message_id])
  end
end
