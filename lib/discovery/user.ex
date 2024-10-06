defmodule Turms.User do
  @moduledoc """
  Ecto model for users table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:public, :boolean, default: false)
    field(:password, :string, redact: true, default: nil, virtual: true)
    field(:hashed_password, :string, redact: true, default: nil)
    field(:vanity, :string, primary_key: true)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:vanity, :name, :password, :public])
    |> validate_required([:vanity, :name, :public])
    |> unique_constraint(:vanity)
    |> hash_password()
  end

  # This function hashes the password before saving it.
  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        # If no password change, skip hashing.
        changeset

      password ->
        hashed_password = Argon2.hash_pwd_salt(password)
        put_change(changeset, :hashed_password, hashed_password)
    end
  end
end
