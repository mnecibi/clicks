defmodule ClicksWeb.CursorPositionsLive.Index do
  alias ClicksWeb.Presence

  use ClicksWeb, :live_view

  @clicks_cluster "clicks"

  @impl true
  def mount(_params, %{"user" => user}, socket) do
    Presence.track(self(), @clicks_cluster, socket.id, %{
      socket_id: socket.id,
      x: 50,
      y: 50,
      name: user,
      score: 0
    })

    ClicksWeb.Endpoint.subscribe(@clicks_cluster)

    initial_users =
      Presence.list(@clicks_cluster)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(:user, user)
      |> assign(:users, initial_users)
      |> assign(:socket_id, socket.id)

    {:ok, updated}
  end

  @impl true
  def handle_event("cursor-move", %{"x" => x, "y" => y}, socket) do
    metas =
      Presence.get_by_key(@clicks_cluster, socket.id)[:metas]
      |> List.first()
      |> Map.merge(%{x: x, y: y})

    Presence.update(self(), @clicks_cluster, socket.id, metas)

    {:noreply, socket}
  end

  def handle_event("click", _params, socket) do
    metas =
      Presence.get_by_key(@clicks_cluster, socket.id)[:metas]
      |> List.first()

    Presence.update(self(), @clicks_cluster, socket.id, %{metas | score: metas.score + 1})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users =
      Presence.list(@clicks_cluster)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(users: users)
      |> assign(socket_id: socket.id)

    {:noreply, updated}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div phx-click="click" class="h-screen w-screen relative outline-none bg-gray-200">
      <div class="absolute right-0 top-0 text-sm text-gray-500 outline-none">
        <div>Current node: <%= node() %></div>
        <div>Other nodes: <%= "[#{Enum.join(Node.list(), ",")}]" %></div>
      </div>

      <div class="flex flex-col gap-4 items-center justify-center h-full w-full">
        <div class="text-xl font-bold">LEADERBOARD</div>
        <div class="flex flex-col gap-2 items-center text-lg">
          <%= for {user, index} <- Enum.sort(@users, &(&1.score >= &2.score)) |> Enum.with_index() do %>
            <% color = ClicksWeb.Colors.getHSL(user.name) %>
            <div style={"color: #{color};"}>
              <%= "#{index + 1} - #{user.name}: #{user.score}" %>
            </div>
          <% end %>
        </div>
      </div>

      <ul class="list-none" id="cursors" phx-hook="TrackClientCursor">
        <%= for user <- @users do %>
          <% color = ClicksWeb.Colors.getHSL(user.name) %>
          <li
            style={"color: #{color}; left: #{user.x}%; top: #{user.y}%"}
            class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden"
          >
            <svg
              version="1.1"
              width="25px"
              height="25px"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              viewBox="0 0 21 21"
            >
              <polygon fill="black" points="8.2,20.9 8.2,4.9 19.8,16.5 13,16.5 12.6,16.6" />
              <polygon fill="currentColor" points="9.2,7.3 9.2,18.5 12.2,15.6 12.6,15.5 17.4,15.5" />
            </svg>
            <span style={"background-color: #{color};"} class="mt-1 ml-4 px-1 text-sm text-white">
              <%= user.name %>
            </span>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
