defmodule Note.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :digest, :string

      timestamps
    end

  end
end
