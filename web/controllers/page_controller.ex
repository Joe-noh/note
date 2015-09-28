defmodule Note.PageController do
  use Note.Web, :controller

  alias Note.Page

  plug :scrub_params, "page" when action in [:create, :update]

  def index(conn, _params) do
    pages = Repo.all(assoc conn.assigns.current_user, :pages)
    render(conn, "index.json", pages: pages)
  end

  def create(conn, %{"page" => page_params}) do
    changeset = conn.assigns.current_user
      |> Ecto.Model.build(:pages)
      |> Page.changeset(page_params)

    case Repo.insert(changeset) do
      {:ok, page} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_page_path(conn, :show, page,conn.assigns.current_user))
        |> render("show.json", page: page)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Note.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    page = Repo.get!(Page, id)
    render conn, "show.json", page: page
  end

  def update(conn, %{"id" => id, "page" => page_params}) do
    changeset = Repo.get!(Page, id) |> Page.changeset(page_params)

    case Repo.update(changeset) do
      {:ok, page} ->
        render(conn, "show.json", page: page)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Note.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Page, id) |> Repo.delete!

    send_resp(conn, :no_content, "")
  end
end
