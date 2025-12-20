defmodule TurmsWeb.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by tests that require setting up
  a connection on channels.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels.
      import Phoenix.ChannelTest
      import TurmsWeb.ChannelCase

      # The default endpoint for testing.
      @endpoint TurmsWeb.Endpoint
    end
  end

  setup tags do
    Turms.DataCase.setup_sandbox(tags)
    :ok
  end
end
