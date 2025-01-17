defmodule TunezWeb.Graphql.UserTest do
  use TunezWeb.ConnCase, async: true

  describe "queries" do
    @tag :skip
    test "signInWithPassword" do
      # user = generate(user(email: "test@test.com", password: "password"))

      # assert {:ok, resp} =
      #          """
      #          query signInWithPassword($email: String!, $password: String!) {
      #            signInWithPassword(email: $email, password: $password) {
      #              id
      #              token
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"email" => "test@test.com", "password" => "password"}
      #          )

      # result = resp.data["signInWithPassword"]
      # assert result["id"] == user.id
      # assert result["token"] != nil
    end
  end

  describe "mutations" do
    @tag :skip
    test "registerWithPassword" do
      # assert {:ok, resp} =
      #          """
      #          mutation registerWithPassword($input: RegisterWithPasswordInput!) {
      #            registerWithPassword(input: $input) {
      #              errors { message }
      #              metadata { token }
      #              result { id }
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{
      #              "input" => %{
      #                "email" => "test2@test.com",
      #                "password" => "password2",
      #                "passwordConfirmation" => "password2"
      #              }
      #            }
      #          )

      # data = resp.data["registerWithPassword"]
      # assert Enum.empty?(data["errors"])
      # assert data["metadata"]["token"] != nil
      # assert data["result"]["id"] != nil
    end
  end
end
