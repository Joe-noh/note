defmodule Note.PageController do
  use Note.Web, :controller

  alias Note.Page

  plug :scrub_params, "page" when action in [:create, :update]

  def index(conn, _params) do
    IO.inspect conn
    pages = Repo.all(Page)
    render(conn, "index.json", pages: pages)
  end

  def create(conn, %{"page" => page_params}) do
    IO.inspect conn
    changeset = Page.changeset(%Page{}, page_params)

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
    page = Repo.get!(Page, id)
    changeset = Page.changeset(page, page_params)

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
    page = Repo.get!(Page, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(page)

    send_resp(conn, :no_content, "")
  end
end
