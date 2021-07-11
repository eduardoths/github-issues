defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]
  @default_count 4
  @moduledoc """
  Handles the command line parsing
  """


  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` may be -h or --help, which returns :help.
  It can also be a github username, a project name and (optionally)
  the number of entries to format

  Returns a tuple of `{user, project, count}`, or `:help` if it was given
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h:     :help   ])
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer count}
  end

  defp args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_descending()
    |> get_last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end


  def decode_response(%{status_code: 200, body: body}) do
    body
  end

  def decode_response(%{status_code: status_code, body: _}) do
    IO.puts "Error fetching from Github: #{status_code}"
    System.halt 2
  end

  def sort_descending(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def get_last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end
end
