defmodule ClusterTestWeb.CursorPositionsLiveTest do
  use ClusterTestWeb.ConnCase

  import Phoenix.LiveViewTest
  import ClusterTest.CursorFixtures

  @create_attrs %{y: 42, x: 42}
  @update_attrs %{y: 43, x: 43}
  @invalid_attrs %{y: nil, x: nil}

  defp create_cursor_positions(_) do
    cursor_positions = cursor_positions_fixture()
    %{cursor_positions: cursor_positions}
  end

  describe "Index" do
    setup [:create_cursor_positions]

    test "lists all cursor_positions", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/cursor_positions")

      assert html =~ "Listing Cursor positions"
    end

    test "saves new cursor_positions", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cursor_positions")

      assert index_live |> element("a", "New Cursor positions") |> render_click() =~
               "New Cursor positions"

      assert_patch(index_live, ~p"/cursor_positions/new")

      assert index_live
             |> form("#cursor_positions-form", cursor_positions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cursor_positions-form", cursor_positions: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cursor_positions")

      html = render(index_live)
      assert html =~ "Cursor positions created successfully"
    end

    test "updates cursor_positions in listing", %{conn: conn, cursor_positions: cursor_positions} do
      {:ok, index_live, _html} = live(conn, ~p"/cursor_positions")

      assert index_live |> element("#cursor_positions-#{cursor_positions.id} a", "Edit") |> render_click() =~
               "Edit Cursor positions"

      assert_patch(index_live, ~p"/cursor_positions/#{cursor_positions}/edit")

      assert index_live
             |> form("#cursor_positions-form", cursor_positions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cursor_positions-form", cursor_positions: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cursor_positions")

      html = render(index_live)
      assert html =~ "Cursor positions updated successfully"
    end

    test "deletes cursor_positions in listing", %{conn: conn, cursor_positions: cursor_positions} do
      {:ok, index_live, _html} = live(conn, ~p"/cursor_positions")

      assert index_live |> element("#cursor_positions-#{cursor_positions.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cursor_positions-#{cursor_positions.id}")
    end
  end

  describe "Show" do
    setup [:create_cursor_positions]

    test "displays cursor_positions", %{conn: conn, cursor_positions: cursor_positions} do
      {:ok, _show_live, html} = live(conn, ~p"/cursor_positions/#{cursor_positions}")

      assert html =~ "Show Cursor positions"
    end

    test "updates cursor_positions within modal", %{conn: conn, cursor_positions: cursor_positions} do
      {:ok, show_live, _html} = live(conn, ~p"/cursor_positions/#{cursor_positions}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cursor positions"

      assert_patch(show_live, ~p"/cursor_positions/#{cursor_positions}/show/edit")

      assert show_live
             |> form("#cursor_positions-form", cursor_positions: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#cursor_positions-form", cursor_positions: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cursor_positions/#{cursor_positions}")

      html = render(show_live)
      assert html =~ "Cursor positions updated successfully"
    end
  end
end
