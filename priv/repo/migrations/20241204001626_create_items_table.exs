defmodule Astral.Repo.Migrations.CreateItemsTable do
  use Ecto.Migration

  def change do
    create table(:Items) do
      add :account_id, :string
      add :profile_id, :string
      add :template_id, :string
      add :value, :jsonb
      add :quantity, :integer, default: 1
      add :is_stat, :boolean, default: false
    end

    create unique_index(:Items, [:template_id], name: :items_pkey)
  end
end
