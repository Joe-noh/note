defmodule Note.PageControllerTest do
  use Note.ConnCase

  alias Note.Page
  alias Note.User
  alias Note.Repo

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{body: nil, title: nil}

  @user_attrs %{name: "John Doe", password: "password"}

  setup do
    user = User.changeset(%User{}, @user_attrs) |> Repo.insert!
    page = Ecto.Model.build(user, :pages, @valid_attrs) |> Repo.insert!

    {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)

    conn_without_token = conn |> put_req_header("accept", "application/json")
    conn = conn_without_token |> put_req_header("authorization", token)

    {:ok, conn: conn, user: user, page: page}
  end

  test "index returns all pages of the user", %{conn: conn, user: user} do
    conn = get conn, user_page_path(conn, :index, user)
    response = json_response(conn, 200)["data"]

    assert Enum.count(response) == Enum.count(Repo.preload(user, :pages).pages)
  end

  test "shows chosen resource", %{conn: conn, user: user, page: page} do
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
    page_params = %{title: "Another One", body: "Hey!"}
    conn = post conn, user_page_path(conn, :create, user), page: page_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Page, page_params)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, user_page_path(conn, :create, user), page: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user, page: page} do
    page_params = %{title: "Another One", body: "Hey!"}
    conn = put conn, user_page_path(conn, :update, user, page), page: page_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Page, page_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user, page: page} do
    conn = put conn, user_page_path(conn, :update, user, page), page: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user, page: page} do
    conn = delete conn, user_page_path(conn, :delete, user, page)
    assert response(conn, 204)
    refute Repo.get(Page, page.id)
  end
end
