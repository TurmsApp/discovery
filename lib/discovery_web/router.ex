defmodule TurmsWeb.Router do
  use TurmsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TurmsWeb do
    pipe_through :api
  end
end
