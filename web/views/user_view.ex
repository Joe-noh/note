defmodule Note.UserView do
  use Note.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Note.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Note.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      digest: user.digest}
  end
end
