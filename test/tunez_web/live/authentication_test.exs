defmodule TunezWeb.AuthenticationTest do
  use TunezWeb.ConnCase, async: true

  @tag skip: "Also need to change `_conn` to `conn` below"
  test "register for a new account", %{conn: _conn} do
    # conn
    # |> visit(~p"/")
    # |> click_link("Register")
    # |> within(
    #   "#user-password-register-with-password-wrapper",
    #   fn session ->
    #     session
    #     |> fill_in("Email", with: "newaccount@sevenseacat.net")
    #     |> fill_in("Password", with: "password")
    #     |> fill_in("Password Confirmation", with: "password")
    #     |> click_button("Register")
    #   end
    # )
    # |> assert_path(~p"/")
    # |> assert_has(flash(:info), text: "You are now signed in")
    # |> assert_has("strong", text: "newaccount@sevenseacat.net")
  end

  @tag skip: "Also need to change `_conn` to `conn` below"
  test "sign in to an existing account", %{conn: _conn} do
    # generate(user(email: "other@sevenseacat.net", password: "password"))

    # conn
    # |> visit(~p"/")
    # |> click_link("Sign In")
    # |> within(
    #   "#user-password-sign-in-with-password-wrapper",
    #   fn session ->
    #     session
    #     |> fill_in("Email", with: "other@sevenseacat.net")
    #     |> fill_in("Password", with: "password")
    #     |> click_button("Sign in")
    #   end
    # )
    # |> assert_path(~p"/")
    # |> assert_has(flash(:info), text: "You are now signed in")
    # |> assert_has("strong", text: "other@sevenseacat.net")
  end
end
