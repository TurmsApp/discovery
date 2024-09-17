defmodule Turms.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :public, :boolean, default: false
    field :date, :utc_datetime
    field :password, :string, redact: true
    field :vanity, :string, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:vanity, :name, :password, :date, :public])
    |> validate_required([:vanity, :name, :password, :date, :public])
    |> unique_constraint(:vanity)
  end
end
