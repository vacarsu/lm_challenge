defmodule LmChlng.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table("documents") do
      add :plaintiffs, :binary
      add :plaintiffs_hashed, :binary
      add :defendants, :binary
      add :defendants_hashed, :binary
      add :file_path, :string
      add :processed, :boolean, default: false
    end
  end

  def down do
    drop table("documents")
  end
end
