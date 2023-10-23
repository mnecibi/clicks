defmodule ClusterTest.CursorTest do
  use ClusterTest.DataCase

  alias ClusterTest.Cursor

  describe "cursor_positions" do
    alias ClusterTest.Cursor.CursorPositions

    import ClusterTest.CursorFixtures

    @invalid_attrs %{y: nil, x: nil}

    test "list_cursor_positions/0 returns all cursor_positions" do
      cursor_positions = cursor_positions_fixture()
      assert Cursor.list_cursor_positions() == [cursor_positions]
    end

    test "get_cursor_positions!/1 returns the cursor_positions with given id" do
      cursor_positions = cursor_positions_fixture()
      assert Cursor.get_cursor_positions!(cursor_positions.id) == cursor_positions
    end

    test "create_cursor_positions/1 with valid data creates a cursor_positions" do
      valid_attrs = %{y: 42, x: 42}

      assert {:ok, %CursorPositions{} = cursor_positions} = Cursor.create_cursor_positions(valid_attrs)
      assert cursor_positions.y == 42
      assert cursor_positions.x == 42
    end

    test "create_cursor_positions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cursor.create_cursor_positions(@invalid_attrs)
    end

    test "update_cursor_positions/2 with valid data updates the cursor_positions" do
      cursor_positions = cursor_positions_fixture()
      update_attrs = %{y: 43, x: 43}

      assert {:ok, %CursorPositions{} = cursor_positions} = Cursor.update_cursor_positions(cursor_positions, update_attrs)
      assert cursor_positions.y == 43
      assert cursor_positions.x == 43
    end

    test "update_cursor_positions/2 with invalid data returns error changeset" do
      cursor_positions = cursor_positions_fixture()
      assert {:error, %Ecto.Changeset{}} = Cursor.update_cursor_positions(cursor_positions, @invalid_attrs)
      assert cursor_positions == Cursor.get_cursor_positions!(cursor_positions.id)
    end

    test "delete_cursor_positions/1 deletes the cursor_positions" do
      cursor_positions = cursor_positions_fixture()
      assert {:ok, %CursorPositions{}} = Cursor.delete_cursor_positions(cursor_positions)
      assert_raise Ecto.NoResultsError, fn -> Cursor.get_cursor_positions!(cursor_positions.id) end
    end

    test "change_cursor_positions/1 returns a cursor_positions changeset" do
      cursor_positions = cursor_positions_fixture()
      assert %Ecto.Changeset{} = Cursor.change_cursor_positions(cursor_positions)
    end
  end
end
