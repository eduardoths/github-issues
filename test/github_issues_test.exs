defmodule GithubIssuesTest do
  use ExUnit.Case, async: true
  doctest Issues

  import Issues.GithubIssues, only: [fetch: 2]

  test "Check if connection is established" do
    res = fetch("elixir-lang", "elixir")
    assert res[:status_code] == 200
  end

  test "Checking error 404: not found" do
    res = fetch("eduardothsantos", "asdjasdjlasdaaslj")
    assert res[:status_code] == 404
  end
end
