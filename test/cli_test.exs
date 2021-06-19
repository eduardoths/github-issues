defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

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
end
