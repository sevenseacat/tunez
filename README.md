# Tunez

The starter app for the upcoming [Ash Framework](https://pragprog.com/titles/ldash/ash-framework/) book.

## Setup

The versions of Elixir and Erlang we're using are specified in the `.tool-versions` file. If you're using `asdf` to manage installed versions of languages, run `asdf install` to install them. Tunez should work with any reasonably recent versions, but newer is better!

You'll also need NodeJS installed for managing JavaScript dependencies - we don't need any specific version, as long as you can run `npm install`, that's okay!

Once you have those installed:

* Run `npm install --prefix assets` to install JavaScript dependencies
* Run `mix setup` to install and setup Elixir dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
