defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :firstname, :string
      add :lastname, :string

      timestamps()
    end

    create unique_index(:users, [:email, :username])

    # create constraint(
    #   "users",
    #   "is_email_valid",
    #   check: "email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'"
    # )
  end
end