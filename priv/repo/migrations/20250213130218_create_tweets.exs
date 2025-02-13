defmodule Twitter.Repo.Migrations.CreateTimelines do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :nickname, :string
      add :content, :text

      timestamps(type: :utc_datetime)
    end
  end
end
