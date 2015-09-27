defmodule Note.PageView do
  use Note.Web, :view

  def render("index.json", %{pages: pages}) do
    %{data: render_many(pages, Note.PageView, "page.json")}
  end

  def render("show.json", %{page: page}) do
    %{data: render_one(page, Note.PageView, "page.json")}
  end

  def render("page.json", %{page: page}) do
    %{id: page.id,
      title: page.title,
      body: page.body,
      user_id: page.user_id}
  end
end
