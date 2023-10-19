defmodule Tutorials.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    has_one :user, Tutorials.Users.User

    timestamps(type: :utc_datetime)
  end

  # Do something before saving to the database
  # changeset used to create a "draft" of data that can be inspected and transformed before saving to the database.
  # It is commonly used during the process of adding, updating or deleting data from the database.
  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email])
    |> validate_required([:hash_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset) do
    change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))
  end

  def put_password_hash(changeset), do: changeset
end
