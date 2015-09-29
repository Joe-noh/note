defmodule Note.PageControllerTest do
  use Note.ConnCase

  alias Note.Page
  alias Note.Repo

  @invalid_attrs %{body: nil, title: nil}

  setup do
    user = Forge.saved_user(Repo)
    page = Forge.saved_page(Repo, user_id: user.id)

    {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)

    conn_without_token = conn |> put_req_header("accept", "application/json")
    conn = conn_without_token |> put_req_header("authorization", token)

    {:ok, conn: conn, conn_without_token: conn_without_token, page: page}
  end

  test "index returns all pages of the user", %{conn: conn} do
    conn = get(conn, page_path(conn, :index))
    user = conn.assigns.current_user
    response = json_response(conn, 200)["pages"]

    assert Enum.count(response) == Enum.count(Repo.preload(user, :pages).pages)
  end

  test "index returns 401 if the token is missing", %{conn_without_token: conn} do
    conn = get(conn, page_path(conn, :index))

    assert json_response(conn, 401)["errors"]
  end

  test "show returns a page", %{conn: conn, page: page} do
    conn = get(conn, page_path(conn, :show, page))

    assert json_response(conn, 200)["page"] == %{
      "id"    => page.id,
      "title" => page.title,
      "body"  => page.body
    }
  end

  test "show returns 401 if the token is missing", %{conn_without_token: conn, page: page} do
    conn = get(conn, page_path(conn, :show, page))

    assert json_response(conn, 401)["errors"]
  end

  test "show throws an error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get(conn, page_path(conn, :show, -1))
    end
  end

  test "create returns the created page", %{conn: conn} do
    page_params = %{title: "Another One", body: "Hey!"}
    conn = post(conn, page_path(conn, :create), page: page_params)

    assert json_response(conn, 201)["page"]["id"]
    assert Repo.get_by(Page, page_params)
  end

  test "create returns 401 if the token is missing", %{conn_without_token: conn} do
    page_params = %{title: "Another One", body: "Hey!"}
    conn = post(conn, page_path(conn, :create), page: page_params)

    assert json_response(conn, 401)["errors"]
  end

  test "create returns errors when given data is invalid", %{conn: conn} do
    conn = post(conn, page_path(conn, :create), page: @invalid_attrs)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "update returns the updated page when data is valid", %{conn: conn, page: page} do
    page_params = %{title: "Another One", body: "Hey!"}
    conn = put(conn, page_path(conn, :update, page), page: page_params)

    assert json_response(conn, 200)["page"]["id"]
    assert Repo.get_by(Page, page_params)
  end

  test "update returns 401 if the token is missing", %{conn_without_token: conn, page: page} do
    page_params = %{title: "Another One", body: "Hey!"}
    conn = put(conn, page_path(conn, :update, page), page: page_params)

    assert json_response(conn, 401)["errors"]
  end

  test "update returns errors when given data is invalid", %{conn: conn, page: page} do
    conn = put(conn, page_path(conn, :update, page), page: @invalid_attrs)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "delete returns 204", %{conn: conn, page: page} do
    conn = delete(conn, page_path(conn, :delete, page))

    assert response(conn, 204)
    refute Repo.get(Page, page.id)
  end

  test "delete returns 401 if the token is missing", %{conn_without_token: conn, page: page} do
    conn = delete(conn, page_path(conn, :delete, page))

    assert json_response(conn, 401)["errors"]
  end
end
