defmodule Turms.Message do
  @moduledoc """
  Ecto model for messages table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:content, :string, redact: true)
    # field must be hashed client-site.
    field(:from, :string)

    belongs_to(:user, Turms.User,
      foreign_key: :user_vanity,
      references: :vanity,
      type: :string
    )

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :date, :user_vanity])
    |> validate_required([:content, :date, :user_vanity])
  end
end
