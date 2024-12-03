defmodule Astral.Repo do
  use Ecto.Repo,
    otp_app: :astral,
    adapter: Ecto.Adapters.Postgres
end
