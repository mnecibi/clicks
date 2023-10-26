defmodule Clicks.CursorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clicks.Cursor` context.
  """

  @doc """
  Generate a cursor_positions.
  """
  def cursor_positions_fixture(attrs \\ %{}) do
    {:ok, cursor_positions} =
      attrs
      |> Enum.into(%{
        x: 42,
        y: 42
      })
      |> Clicks.Cursor.create_cursor_positions()

    cursor_positions
  end
end
