defmodule Turms.Message do
  @moduledoc """
  Ecto model for messages table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string, redact: true
    field :date, :utc_datetime
    field :attachements, {:array, :integer}
    field :user_vanity, :id

    has_many :attachments, Turms.Attachment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :date, :attachements])
    |> validate_required([:message, :date, :attachements])
  end
end
