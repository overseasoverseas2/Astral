defmodule Astral.Repo.Migrations.AddIdToProfiles do
  use Ecto.Migration

  def change do
    alter table(:Profiles) do
      add :id, :serial, primary_key: true
    end
  end
end
