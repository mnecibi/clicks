defmodule ClusterTestWeb.PageController do
  use ClusterTestWeb, :controller

  def index(conn, _params) do
    session = conn |> get_session()

    case session do
      %{"user" => _user} ->
        conn
        |> redirect(to: "/cursors")

      _ ->
        conn
        |> put_session(:user, ClusterTestWeb.Names.generate())
        |> configure_session(renew: true)
        |> redirect(to: "/cursors")
    end
  end
end
