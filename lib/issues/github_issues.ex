defmodule Issues.GithubIssues do

  require Logger

  @user_agent [ {"User-agent", "Elixir santos.eduardothomaz@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)


  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}")

    get_user_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end


  def get_user_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end


  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status code=#{status_code}")
    Logger.debug(fn -> inspect(body) end)
    %{status_code: status_code,
      body: Poison.Parser.parse!(body)}
  end
end
