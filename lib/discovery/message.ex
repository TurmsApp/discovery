defmodule Turms.Message do
  @moduledoc """
  Ecto model for messages table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:content, :string, redact: true)
    belongs_to(:user, Turms.User, foreign_key: :user_vanity, references:
                :vanity, type: :string)
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_vanity])
    |> validate_required([:content, :user_vanity])
  end
end
