defmodule Note.PageControllerTest do
  use Note.ConnCase

  alias Note.Page
  alias Note.User
  alias Note.Repo

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  @user_attrs %{name: "John Doe", password: "password"}

  setup do
    user = User.changeset(%User{}, @user_attrs) |> Repo.insert!
    conn = conn() |> put_req_header("accept", "application/json")

    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_page_path(conn, :index, user)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    page = Repo.insert! %Page{user_id: user.id}
    conn = get conn, user_page_path(conn, :show, user, page)
    assert json_response(conn, 200)["data"] == %{
      "id" => page.id,
      "title" => page.title,
      "body" => page.body,
      "user_id" => page.user_id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, user: user} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_page_path(conn, :show, user, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    conn = post conn, user_page_path(conn, :create, user), page: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Page, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, user_page_path(conn, :create, user), page: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    page = Repo.insert! %Page{}
    conn = put conn, user_page_path(conn, :update, user, page), page: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Page, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    page = Repo.insert! %Page{}
    conn = put conn, user_page_path(conn, :update, user, page), page: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    page = Repo.insert! %Page{}
    conn = delete conn, user_page_path(conn, :delete, user, page)
    assert response(conn, 204)
    refute Repo.get(Page, page.id)
  end
end
