defmodule Note.SessionController do
  use Note.Web, :controller

  alias Note.User

  plug :scrub_params, "session"

  def create(conn, %{"session" => %{"name" => name, "password" => password}}) do
    case User.authenticate(name, password) do
      nil  -> unauthorized(conn)
      user -> authorized(conn, user)
    end
  end

  def create(conn, _params), do: unauthorized(conn)

  defp authorized(conn, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)

    conn
    |> put_status(:created)
    |> render("auth.json", user: user, token: token)
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> render(Note.ErrorView, "401.json")
  end
end
