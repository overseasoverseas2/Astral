defmodule Astral.Database.Tables.Accounts do
  use Ecto.Schema
  import Ecto.Changeset

  schema "Accounts" do
    field :account_id, :string, primary_key: true
    field :email, :string
    field :password, :string
    field :username, :string
    field :banned, :boolean, default: false
    field :is_server, :boolean, default: false
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_id, :email, :password, :username, :banned, :is_server])
    |> validate_required([:account_id, :email, :password, :username])
  end
end
