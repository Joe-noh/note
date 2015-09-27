defmodule Note.SessionControllerTest do
  use Note.ConnCase

  alias Note.User

  @valid_attrs  %{name: "John Doe", password: "password"}
  @invalid_attrs %{}

  @user_params @valid_attrs

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    user = User.changeset(%User{}, @user_params) |> Repo.insert!
    {:ok, %{conn: conn, user: user}}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert json_response(conn, 201)["user"]
    assert json_response(conn, 201)["token"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert json_response(conn, 401)["errors"] != %{}
  end
end
