defmodule CliTest do
  use ExUnit.Case, async: true
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_descending: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",         "anything"]) == :help
    assert parse_args(["--help", "anotherthing"]) == :help
  end

  test "three values returned if three were given" do
    assert parse_args(["user", "project", "7"]) == {"user", "project", 7}
  end

  test "count is defaulted if only two values were given" do
    assert parse_args(["user", "projecto"]) == {"user", "projecto", 4}
  end

  test "sort descending order in the correct way" do
    fake_list = for value <- ["a", "z", "c"],
      do: %{"created_at" => value,"unused_data" => "a"}
    result = sort_descending(fake_list)
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{ z c a }
  end
end
