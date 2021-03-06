defmodule MyApp.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Account.{Clock, Workingtime, Team}

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :firstname, :string
    field :lastname, :string
    field :role, :string
    has_many :clocks, Clock
    has_many :workingtimes, Workingtime
    has_many :teams, Team

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :firstname, :lastname, :role])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/(\w+)@([\w+)\.([\w.]{2,4})/)
    |> validate_length(:password, min: 8)
    |> validate_inclusion(:role, ~w(user manager generalmanager admin))
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          put_change(changeset, :password_hash, Base.encode16(:crypto.hash(:sha256, "#{password}_s3cr3tp4s$xXxX_______try_to_crack_this_lol")))
      _ ->
          changeset
    end
  end
end
