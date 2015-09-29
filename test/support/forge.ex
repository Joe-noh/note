defmodule Forge do
  use Blacksmith

  @save_one_function &Forge.save/2
  @save_all_function &Forge.save_all/2

  register :user,
    __struct__: Note.User,
    name: "John Doe",
    digest: Note.User.digest("password")

  register :page,
    __struct__: Note.Page,
    title: Faker.Lorem.sentence,
    body: Faker.Lorem.paragraph

  def save(repo, params) do
    params |> repo.insert!
  end

  def save_all(repo, params_list) do
    Enum.each params_list, &repo.insert!/1
  end
end
