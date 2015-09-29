defmodule Note.UserControllerTest do
  use Note.ConnCase

  alias Note.User

  @valid_attrs %{password: "my_secret_password", name: "John Doe"}
  @invalid_attrs %{}

  setup do
    user = Forge.saved_user(Repo) #User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)

    conn_without_token = conn |> put_req_header("accept", "application/json")
    conn = conn_without_token |> put_req_header("authorization", token)

    {:ok, %{conn: conn, conn_without_token: conn_without_token, user: user}}
  end

  test "show returns a user", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)

    assert json_response(conn, 200)["user"] == %{"id" => user.id, "name" => user.name}
  end

  test "show returns 401 if the token is missing", %{conn_without_token: conn, user: user} do
    conn = conn |> get(user_path(conn, :show, user))

    assert json_response(conn, 401)["errors"]
  end

  test "show throws error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "create returns the created user even if the token isn't given", %{conn_without_token: conn} do
    name = "John Smith"
    user_params = %{@valid_attrs | name: name}
    conn = conn |> post(user_path(conn, :create), user: user_params)

    assert json_response(conn, 201)["user"]["id"]
    assert Repo.get_by(User, name: name)
  end

  test "create returns 422 when givne data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates returns an updated user", %{conn: conn, user: user} do
    new_name = "John Smith"
    user_params = %{@valid_attrs | name: new_name}
    conn = put conn, user_path(conn, :update, user), user: user_params

    assert json_response(conn, 200)["user"]["id"]
    assert Repo.get_by(User, name: new_name)
  end

  test "update returns 401 if the token is missing", %{conn_without_token: conn, user: user} do
    user_params = %{@valid_attrs | name: "John Smith"}
    conn = put(conn, user_path(conn, :update, user), user: user_params)

    assert json_response(conn, 401)["errors"]
  end

  test "update returns 422 when given data is invalid", %{conn: conn, user: user} do
    conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "delete returns 204", %{conn: conn, user: user} do
    conn = delete(conn, user_path(conn, :delete, user))

    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

  test "delete returns 401 if the token is missing", %{conn_without_token: conn, user: user} do
    conn = delete(conn, user_path(conn, :delete, user))

    assert json_response(conn, 401)["errors"]
  end
end
