defmodule Clicks.Repo.Migrations.CreateCursorPositions do
  use Ecto.Migration

  def change do
    create table(:cursor_positions) do
      add :x, :integer
      add :y, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
