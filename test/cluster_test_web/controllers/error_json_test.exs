defmodule ClusterTestWeb.ErrorJSONTest do
  use ClusterTestWeb.ConnCase, async: true

  test "renders 404" do
    assert ClusterTestWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ClusterTestWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
