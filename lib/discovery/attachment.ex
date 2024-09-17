defmodule Turms.Attachment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attachments" do
    field :filename, :string
    field :content_type, :string
    field :blob, :binary

    belongs_to :message, Turms.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:filename, :content_type, :blob])
    |> validate_required([:filename, :content_type, :blob])
  end
end
