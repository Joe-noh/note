defmodule Note.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Note.User
  alias Note.Repo

  def for_token(user = %User{}), do: {:ok, "user:#{user.id}"}
  def for_token(_), do: {:error, "unsupported resource type"}

  def from_token("user:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "unsupported resource type"}
end
