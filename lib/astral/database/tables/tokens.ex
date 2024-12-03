defmodule Astral.Database.Tables.Tokens do
  use Ecto.Schema
  import Ecto.Changeset

  schema "Tokens" do
    field :token, :string, primary_key: true
    field :account_id, :string
    field :type, :string

    timestamps()
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :account_id, :type])
    |> validate_required([:token, :account_id, :type])
  end
end
