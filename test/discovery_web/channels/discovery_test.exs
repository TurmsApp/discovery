defmodule TurmsWeb.DiscoveryChannelTest do
  use TurmsWeb.ChannelCase

  @user_id "test@example.com"

  setup do
    {:ok, _, socket} =
      TurmsWeb.UserSocket
      |> socket("", %{user_id: @user_id})
      |> subscribe_and_join(TurmsWeb.DiscoverChannel, "")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"ping" => "pong"})
    assert_reply ref, :ok, %{"ping" => "pong"}
  end

  test "sdp replies with status ok", %{socket: socket} do
    ref =
      push(socket, "sdp", %{
        "type" => "offer",
        "sdp" => "v=0 o=- 27811528616..."
      })

    assert_reply ref, :ok
  end
end
