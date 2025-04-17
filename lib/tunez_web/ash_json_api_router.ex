defmodule TunezWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Tunez.Music],
    open_api: "/open_api",
    open_api_title: "Tunez API Documentation",
    open_api_version: to_string(Application.spec(:tunez, :vsn))
end
