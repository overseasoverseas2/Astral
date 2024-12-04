defmodule Astral.Repo.Migrations.Waah do
  use Ecto.Migration

  def change do
    execute("DROP INDEX IF EXISTS Profiles_type_index")
    execute("DROP INDEX IF EXISTS items_pkey")
  end
end
