defmodule GithubIssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.GithubIssues, only: [fetch: 2]

  test "Check if connection is established" do
    res = fetch("eduardothsantos", "github-issues")
    assert res[:status] == :ok
    assert res[:status_code] == 200
  end

  test "Checking error 404: not found" do
    res = fetch("eduardothsantos", "asdjasdjlasdaaslj")
    assert res[:status] == :error
    assert res[:status_code] == 404
  end
end
