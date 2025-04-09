defmodule TunezWeb.Graphql.UserTest do
  use TunezWeb.ConnCase, async: true

  describe "queries" do
    @tag :skip
    test "signInUser" do
      # user = generate(user(email: "test@test.com", password: "password"))

      # assert {:ok, resp} =
      #          """
      #          query signInUser($email: String!, $password: String!) {
      #            signInUser(email: $email, password: $password) {
      #              id
      #              token
      #            }
      #          }
      #          """
      #          |> Absinthe.run(TunezWeb.GraphqlSchema,
      #            variables: %{"email" => "test@test.com", "password" => "password"}
      #          )

      # result = resp.data["signInUser"]
      # assert result["id"] == user.id
      # assert result["token"] != nil
    end
  end

  describe "mutations" do
    @tag :skip
    test "registerUser" do
      # assert {:ok, resp} =
      #          """
      #          mutation registerUser($input: RegisterUserInput!) {
      #            registerUser(input: $input) {
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

      # data = resp.data["registerUser"]
      # assert Enum.empty?(data["errors"])
      # assert data["metadata"]["token"] != nil
      # assert data["result"]["id"] != nil
    end
  end
end
