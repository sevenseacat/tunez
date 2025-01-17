defmodule TunezWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use TunezWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint TunezWeb.Endpoint

      use TunezWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest, except: [get: 3, delete: 3]
      import TunezWeb.ConnCase
      import Tunez.Support.Helpers
      import Tunez.Generator
      import PhoenixTest
    end
  end

  setup tags do
    Tunez.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that creates and then logs in users.

      setup :insert_and_authenticate_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def insert_and_authenticate_user(conn, role \\ :user)

  def insert_and_authenticate_user(%{conn: conn}, role) do
    user = Tunez.Generator.generate(Tunez.Generator.user(role: role))
    %{conn: log_in_user(conn, user), user: user}
  end

  def insert_and_authenticate_user(%Plug.Conn{} = conn, role) do
    %{conn: conn}
    |> insert_and_authenticate_user(role)
    |> Map.fetch!(:conn)
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> AshAuthentication.Plug.Helpers.store_in_session(user)
  end
end
