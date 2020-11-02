defmodule MyApp.TimeTrackers.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Accounts.User

  schema "workingtimes" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
  end
end