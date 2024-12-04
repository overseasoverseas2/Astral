defmodule Astral.Repo.Migrations.RemoveUniqueConstraintFromTokens do
  use Ecto.Migration

  def change do
    execute("DROP INDEX IF EXISTS Tokens_token_index")
  end
end
