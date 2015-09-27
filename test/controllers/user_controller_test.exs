defmodule Note.UserControllerTest do
  use Note.ConnCase

  alias Note.User

  @valid_attrs %{password: "my_secret_password", name: "John Doe"}
  @invalid_attrs %{}

  setup do
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)

    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", token)
    {:ok, conn: conn, user: user}
  end

  test "lists all users on index", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["users"] == [%{"id" => user.id, "name" => user.name}]
  end

  test "index returns 401 if the token is missing", %{conn: conn} do
    conn = conn
      |> put_req_header("authorization", "")
      |> get(user_path(conn, :index))

    assert json_response(conn, 401)["errors"]
  end

  test "shows chosen user", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["user"] == %{"id" => user.id, "name" => user.name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders user when data is valid", %{conn: conn} do
    name = "John Smith"
    conn = conn
      |> put_req_header("authorization", "")
      |> post(user_path(conn, :create), user: %{@valid_attrs | name: name})

    assert json_response(conn, 201)["user"]["id"]
    assert Repo.get_by(User, name: name)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen user when data is valid", %{conn: conn, user: user} do
    new_name = "John Smith"
    conn = put conn, user_path(conn, :update, user), user: %{@valid_attrs | name: new_name}
    assert json_response(conn, 200)["user"]["id"]
    assert Repo.get_by(User, name: new_name)
  end

  test "does not update chosen resource and renders errors when user is invalid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
