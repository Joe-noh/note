defmodule Note.User do
  use Note.Web, :model

  alias Note.User
  alias Note.Repo

  schema "users" do
    field :name, :string
    field :digest, :string
    field :password, :string, virtual: true

    timestamps
  end

  before_insert __MODULE__, :generate_digest

  @required_fields ~w(name password)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def authenticate(name, password) do
    case Repo.get_by(User, name: name) do
      nil  -> Comeonin.Bcrypt.dummy_checkpw()
      user -> do_authenticate(user, password)
    end
  end

  defp do_authenticate(user, password) do
    if Comeonin.Bcrypt.checkpw(password, user.digest), do: user
  end

  def generate_digest(conn) do
    if conn.params && (password = Map.get(conn.params, "password")) do
      put_change(conn, :digest, digest(password))
    else
      conn
    end
  end

  defp digest(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
