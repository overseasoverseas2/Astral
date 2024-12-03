defmodule Astral.Database.Tables.Profiles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "Profiles" do
    field :account_id, :string
    field :type, :string
    field :revision, :integer
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:account_id, :type, :revision])
    |> validate_required([:account_id, :type, :revision])
    |> unique_constraint(:type, name: :profiles_pkey)
  end
end
