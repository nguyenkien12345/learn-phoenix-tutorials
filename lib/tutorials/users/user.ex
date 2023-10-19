defmodule Tutorials.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :full_name, :string
    field :gender, :string
    field :biography, :string
    belongs_to :account, Tutorials.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  # Do something before saving to the database
  # changeset used to create a "draft" of data that can be inspected and transformed before saving to the database.
  # It is commonly used during the process of adding, updating or deleting data from the database.
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :full_name, :gender, :biography])
    |> validate_required([:account_id])
  end
end
