defmodule Note.UserTest do
  use Note.ModelCase

  alias Note.User
  alias Note.Repo

  @valid_attrs %{password: "my_secret_password", name: "John Doe"}
  @invalid_attrs %{}

  setup do
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!

    {:ok, %{user: user}}
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "authenticate with correct password", %{user: user} do
    assert User.authenticate(user.name, @valid_attrs[:password])
  end

  test "authenticate with wrong password", %{user: user} do
    refute User.authenticate(user.name, "hogehoge")
  end
end
