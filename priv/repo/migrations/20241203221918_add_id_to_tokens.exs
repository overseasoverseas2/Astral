defmodule Astral.Repo.Migrations.AddIdToTokens do
  use Ecto.Migration

  def change do
    alter table(:Tokens) do
      add :id, :serial, primary_key: true
    end
  end
end
