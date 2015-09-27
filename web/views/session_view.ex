defmodule Note.SessionView do
  use Note.Web, :view

  def render("auth.json", %{user: user, token: token}) do
    %{
      user: render_one(user, Note.UserView, "user.json"),
      token: token
    }
  end
end
