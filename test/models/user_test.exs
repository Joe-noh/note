defmodule Note.UserTest do
  use Note.ModelCase

  alias Note.User

  @valid_attrs %{password: "my_secret_password", name: "John Doe"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
