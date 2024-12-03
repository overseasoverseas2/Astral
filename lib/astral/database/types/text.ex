defmodule Astral.Database.Types.Text do
  use Ecto.Type

  @impl true
  def type, do: :text

  @impl true
  def cast(nil), do: {:ok, nil}
  def cast(value) when is_binary(value), do: {:ok, value}
  def cast(_), do: :error

  @impl true
  def load(nil), do: {:ok, nil}
  def load(value) when is_binary(value), do: {:ok, value}
  def load(_), do: :error

  @impl true
  def dump(nil), do: {:ok, nil}
  def dump(value) when is_binary(value), do: {:ok, value}
  def dump(_), do: :error
end
