defmodule Turms.Repo do
  use Ecto.Repo,
    otp_app: :discovery,
    adapter: Ecto.Adapters.Postgres
end
