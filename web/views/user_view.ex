defmodule Note.UserView do
  use Note.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, Note.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Note.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name}
  end
end
