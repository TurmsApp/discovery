defmodule TurmsWeb.Plugs.Message do
  @moduledoc """
  Manage messages.
  """

  @split_by "@"

  # Split the vanity into user vanity and discovery server.
  @spec split_vanity(String.t()) :: [String.t()]
  def split_vanity(vanity) do
    String.split(vanity, @split_by)
  end
end
