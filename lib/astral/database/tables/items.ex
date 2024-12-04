defmodule Astral.Database.Tables.Items do
  use Ecto.Schema
  import Ecto.Changeset

  schema "Items" do
    field :account_id, :string
    field :profile_id, :string
    field :template_id, :string
    field :value, Astral.Database.Types.Jsonb
    field :quantity, :integer, default: 1
    field :is_stat, :boolean, default: false
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom() | binary()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:account_id, :profile_id, :template_id, :value, :quantity, :is_stat])
    |> validate_required([:account_id, :profile_id, :template_id, :value, :quantity, :is_stat])
  end
end
