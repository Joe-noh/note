defmodule Note.User do
  use Note.Web, :model

  schema "users" do
    field :name, :string
    field :digest, :string
    field :password, :string, virtual: true

    timestamps
  end

  before_insert __MODULE__, :generate_digest

  @required_fields ~w(name password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  defp digest(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  def generate_digest(conn) do
    if conn.params && (password = Map.get(conn.params, "password")) do
      put_change(conn, :digest, digest(password))
    else
      conn
    end
  end
end
