defmodule ClusterTest.CursorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ClusterTest.Cursor` context.
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
      |> ClusterTest.Cursor.create_cursor_positions()

    cursor_positions
  end
end
