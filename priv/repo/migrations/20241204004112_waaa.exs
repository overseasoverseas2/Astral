defmodule Astral.Repo.Migrations.Waaa do
  use Ecto.Migration

  def change do
    drop index(:Profiles, [:type], name: :Profiles_type_index)
  end
end
