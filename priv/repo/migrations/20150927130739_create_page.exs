defmodule Note.Repo.Migrations.CreatePage do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title,   :string
      add :body,    :text
      add :user_id, references(:users), null: false

      timestamps
    end

    create index(:pages, [:user_id])
  end
end
